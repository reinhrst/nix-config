-- Enable the Hammerspoon console for debugging (Cmd+Shift+H to toggle)
hs.hotkey.bind({"cmd", "shift"}, "H", function() hs.toggleConsole() end)

-- Simple alert on startup
hs.alert.show("Hammerspoon loaded!", 2)

-- Window management hotkey (Cmd+Shift+Left to maximize left half)
hs.hotkey.bind({"cmd", "shift"}, "Left", function()
  local win = hs.window.focusedWindow()
  if not win then
    hs.alert.show("No focused window")
    return
  end
  
  local screen = win:screen()
  if not screen then
    hs.alert.show("No screen found")
    return
  end
  
  local max = screen:frame()
  local f = {
    x = max.x,
    y = max.y,
    w = max.w / 2,
    h = max.h
  }
  
  win:setFrame(f)
end)

-- Window management hotkey (Cmd+Shift+Right to maximize right half)
hs.hotkey.bind({"cmd", "shift"}, "Right", function()
  local win = hs.window.focusedWindow()
  if not win then
    hs.alert.show("No focused window")
    return
  end
  
  local screen = win:screen()
  if not screen then
    hs.alert.show("No screen found")
    return
  end
  
  local max = screen:frame()
  local f = {
    x = max.x + (max.w / 2),
    y = max.y,
    w = max.w / 2,
    h = max.h
  }
  
  win:setFrame(f)
end)
