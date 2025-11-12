-- === Simple "Alfred-like" launcher in Hammerspoon ===

-- Change this to whatever hotkey you want
local launcherHotkeyMods = { "alt" }   -- e.g. {"cmd","space"} but Spotlight uses that
local launcherHotkeyKey  = "space"

local GOOGLE_PREFIX = "g "
local MAPS_PREFIX   = "m "
local DEFAULT_SEARCH_URL = "https://www.google.com/search?q="
local MAPS_SEARCH_URL    = "https://www.google.com/maps/search/"

local apps     = {}
local contacts = {}
local chooser  -- forward-declare


------------------------------------------------------------
-- Helpers
------------------------------------------------------------

local function startsWith(str, prefix)
  return str:sub(1, #prefix) == prefix
end

local function trimStart(s)
  return (s or ""):gsub("^%s+", "")
end

------------------------------------------------------------
-- 1) Build app list using `find`
------------------------------------------------------------

local function loadApps()
  -- You can add more paths (~/Applications, /System/Applications, etc.)
  local cmd = [[find /Applications -maxdepth 2 -name "*.app"]]
  local out, status = hs.execute(cmd)

  if not out or status ~= true then
    hs.alert.show("App scan failed")
    return
  end

  for line in out:gmatch("[^\r\n]+") do
    local name = line:match("/([^/]+)%.app$")
    if name then
      table.insert(apps, {
        kind = "app",
        name = name,
        path = line,
      })
    end
  end
end

local function filterAppsPrefix(q)
  local res = {}
  local qLower = q:lower()
  for _, app in ipairs(apps) do
    if app.name:lower():sub(1, #qLower) == qLower then
      table.insert(res, {
        text  = app.name,
        subText = app.path,
        kind  = "app",
        app   = app,
      })
    end
  end
  return res
end

------------------------------------------------------------
-- 2) Build contacts list from Contacts.app (name/email/phone)
------------------------------------------------------------

local function loadContacts()
  local script = [[
    set outText to ""
    tell application "Contacts"
      repeat with p in people
        set theName to name of p as text
        set theEmail to ""
        if (count of emails of p) > 0 then set theEmail to value of first email of p
        set thePhone to ""
        if (count of phones of p) > 0 then set thePhone to value of first phone of p
        set outText to outText & theName & "||" & theEmail & "||" & thePhone & linefeed
      end repeat
    end tell
    return outText
  ]]

  local ok, result = hs.osascript.applescript(script)
  if not ok or not result then
    hs.alert.show(tostring(result))
    return
  end

  for line in result:gmatch("[^\r\n]+") do
    local name, email, phone = line:match("^(.-)%|%|(.-)%|%|(.*)$")
    if name then
      table.insert(contacts, {
        kind  = "contact",
        name  = name,
        email = email,
        phone = phone,
      })
    end
  end
end

local function filterContactsPrefix(q)
  local res = {}
  local qLower = q:lower()

  for _, c in ipairs(contacts) do
    local fields = { c.name or "", c.email or "", c.phone or "" }
    for _, f in ipairs(fields) do
      local fLower = f:lower()
      if fLower ~= "" and fLower:sub(1, #qLower) == qLower then
        table.insert(res, {
          text    = c.name,
          subText = table.concat({ c.email or "", c.phone or "" }, " "),
          kind    = "contact",
          contact = c,
        })
        break
      end
    end
  end

  return res
end

------------------------------------------------------------
-- 3) Math detection + evaluation
------------------------------------------------------------

local function isMathExpression(q)
  -- Only allow digits, operators, parentheses, spaces, decimal point
  return q:match("^[%d%+%-%*/%^%(%)%.%s]+$") ~= nil
end

local function evalMathExpression(q)
  local f, err = load("return " .. q)
  if not f then return nil end
  local ok, result = pcall(f)
  if not ok then return nil end
  return result
end

------------------------------------------------------------
-- 4) Update chooser based on query
------------------------------------------------------------

local function updateChoicesForQuery(rawQuery)
  local q = trimStart(rawQuery or "")

  -- 4a. Google search prefix: "g something"
  if startsWith(q, GOOGLE_PREFIX) then
    local term = q:sub(#GOOGLE_PREFIX + 1)
    if #term > 0 then
      chooser:choices({
        {
          text    = 'Google: "' .. term .. '"',
          subText = "Search Google",
          kind    = "google",
          query   = term,
        },
      })
      return
    end
  end

  -- 4b. Maps prefix: "m something"
  if startsWith(q, MAPS_PREFIX) then
    local term = q:sub(#MAPS_PREFIX + 1)
    if #term > 0 then
      chooser:choices({
        {
          text    = 'Maps: "' .. term .. '"',
          subText = "Search on Google Maps",
          kind    = "maps",
          query   = term,
        },
      })
      return
    end
  end

  -- 4c. Math
  if q ~= "" and isMathExpression(q) then
    local result = evalMathExpression(q)
    if result ~= nil then
      chooser:choices({
        {
          text     = tostring(result),
          subText  = "Math result (press ↩ to copy)",
          kind     = "math",
          expr     = q,
          result   = result,
        },
      })
      return
    end
  end

  -- 4d. Apps + contacts prefix search
  local choices = {}

  if q ~= "" then
    local appChoices      = filterAppsPrefix(q)
    local contactChoices  = filterContactsPrefix(q)

    for _, c in ipairs(appChoices) do table.insert(choices, c) end
    for _, c in ipairs(contactChoices) do table.insert(choices, c) end
  end

  -- 4e. Fallback: default web search
  if #choices == 0 and q ~= "" then
    table.insert(choices, {
      text    = 'Search web for "' .. q .. '"',
      subText = "Default browser search",
      kind    = "defaultSearch",
      query   = q,
    })
  end

  chooser:choices(choices)
end

------------------------------------------------------------
-- 5) What happens when you hit Enter on a choice
------------------------------------------------------------

local function handleChoice(choice)
  if not choice then return end

  if choice.kind == "app" then
    -- Open the .app
    hs.application.open(choice.app.path)

  elseif choice.kind == "contact" then
    -- Show the contact in Contacts.app
    local name = choice.contact.name:gsub('"', '\\"')
    local script = string.format([[
      tell application "Contacts"
        activate
        set thePerson to first person whose name is "%s"
        show thePerson
      end tell
    ]], name)
    hs.osascript.applescript(script)

  elseif choice.kind == "google" then
    local url = DEFAULT_SEARCH_URL .. hs.http.encodeForQuery(choice.query)
    hs.urlevent.openURL(url)

  elseif choice.kind == "maps" then
    local url = MAPS_SEARCH_URL .. hs.http.encodeForQuery(choice.query)
    hs.urlevent.openURL(url)

  elseif choice.kind == "defaultSearch" then
    local url = DEFAULT_SEARCH_URL .. hs.http.encodeForQuery(choice.query)
    hs.urlevent.openURL(url)

  elseif choice.kind == "math" then
    local s = tostring(choice.result)
    hs.pasteboard.setContents(s)
    hs.alert.show("Copied: " .. s)
  end
end

------------------------------------------------------------
-- 6) Create chooser + hotkey
------------------------------------------------------------

chooser = hs.chooser.new(handleChoice)
chooser:queryChangedCallback(updateChoicesForQuery)
chooser:searchSubText(true)  -- so subText is searchable if you want

-- Pre-load indices (only once, at Hammerspoon reload)
loadApps()
loadContacts()

-- Hotkey to show the launcher
hs.hotkey.bind(launcherHotkeyMods, launcherHotkeyKey, function()
  chooser:query("")
  chooser:show()
end)

return true
