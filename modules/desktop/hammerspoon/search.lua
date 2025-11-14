-- === Simple "Alfred-like" launcher in Hammerspoon ===

-- Change this to whatever hotkey you want
local launcherHotkeyMods = { "alt" }   -- e.g. {"cmd","space"} but Spotlight uses that
local launcherHotkeyKey  = "space"

local GOOGLE_PREFIX = "g "
local MAPS_PREFIX   = "m "
local DEFAULT_SEARCH_URL = "https://www.google.com/search?q="
local MAPS_SEARCH_URL    = "https://www.google.com/maps/search/"

local apps     = {}
local applist     = ""
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

local function getAppIcon(appPath)
  -- Method 1: Try to get icon from Info.plist
  local infoPlist = appPath .. "/Contents/Info.plist"
  local cmd = string.format([[/usr/libexec/PlistBuddy -c "Print :CFBundleIconFile" "%s" 2>/dev/null]], infoPlist)
  local iconName, status = hs.execute(cmd)
  
  if iconName and status == true then
    iconName = iconName:gsub("^%s*(.-)%s*$", "%1")  -- trim whitespace
    if not iconName:match("%.icns$") then
      iconName = iconName .. ".icns"
    end
    local iconPath = appPath .. "/Contents/Resources/" .. iconName
    local icon = hs.image.imageFromPath(iconPath)
    if icon then
      return icon
    end
  end
  
  -- Method 2: Fallback - look for any .icns file
  local cmd2 = string.format([[find "%s/Contents/Resources" -name "*.icns" -maxdepth 1 | head -n 1]], appPath)
  local icnsPath, status2 = hs.execute(cmd2)
  if icnsPath and status2 == true then
    icnsPath = icnsPath:gsub("^%s*(.-)%s*$", "%1")
    local icon = hs.image.imageFromPath(icnsPath)
    if icon then
      return icon
    end
  end
  
  -- Method 3: Final fallback
  return hs.image.imageFromAppBundle(appPath)
end

local function loadApps()
  local searchDirs = {
    {path = "/Applications", maxdepth = 2},
    {path = os.getenv("HOME") .. "/Applications", maxdepth = 2},
    {path = "/System/Applications", maxdepth = 1},
  }
  local lines = {}
  for _, dir in ipairs(searchDirs) do
    local cmd = string.format([[find "%s" -maxdepth %d -name "*.app" 2>/dev/null]],
      dir.path, dir.maxdepth)
    local out, status = hs.execute(cmd)

    if not out or status ~= true then
      hs.alert.show(string.format("App scan failed in %s", dir.path))
      return
    end

    for line in out:gmatch("[^\r\n]+") do
      local name = line:match("/([^/]+)%.app$")
      if name then
        table.insert(apps, {
          kind = "app",
          name = name,
          path = line,
          icon = getAppIcon(line),
        })
        table.insert(lines, string.format("%d\t%s", #apps, name))
      end
    end
  end

  applist = table.concat(lines, "\n")
end

local function filterApps(q)
  local out = ""
  local task = hs.task.new("/etc/profiles/per-user/reinoud/bin/fzf",
    function(exitCode, stdoutData, stderrData)
      out = stdoutData
    end,
    {"--filter", q, "--delimiter", "\t", "--with-nth", "2"})
  task:setInput(applist)
  task:start()
  task:waitUntilExit()

  local results = {}
  for line in out:gmatch("[^\r\n]+") do
    local index = line:match("^(%d+)")
    if index then
      local idx = tonumber(index)
      local app = apps[idx]
      if apps[idx] then
        table.insert(results, {
          text  = app.name,
          subText = app.path,
          kind  = "app",
          app   = app,
          image = app.icon,
        })
      end
    end
  end

  return results
end

------------------------------------------------------------
-- 2) Math detection + evaluation
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
-- 3) Update chooser based on query
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

  -- 4d. Apps prefix search
  local choices = {}

  if q ~= "" then
    local appChoices      = filterApps(q)

    for _, c in ipairs(appChoices) do table.insert(choices, c) end
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

-- Hotkey to show the launcher
hs.hotkey.bind(launcherHotkeyMods, launcherHotkeyKey, function()
  chooser:query("")
  chooser:show()
end)

return true
