require("search")
require("windows")

-- Enable the Hammerspoon console for debugging (Cmd+Shift+H to toggle)
hs.hotkey.bind({"cmd", "shift"}, "H", function() hs.toggleConsole() end)

-- Simple alert on startup
hs.alert.show("Hammerspoon loaded!", 2)


