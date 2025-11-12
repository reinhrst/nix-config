---@param cond boolean
local function ternary ( cond , T , F , ...)
    if cond then return T(...) else return F(...) end
end

---@param position "left" | "right" | "full"
local function moveWindow (position)
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
    x = ternary(position == "right", max.x + (max.w / 2), max.x),
    y = max.y,
    w = ternary(position == "left" or position == "right", max.w / 2, max.w),
    h = max.h
  }

  win:setFrame(f)

end

hs.hotkey.bind({"cmd", "control", "option"}, "Left", function()
  moveWindow("left")
end)

hs.hotkey.bind({"cmd", "control", "option"}, "Right", function()
  moveWindow("right")
end)

hs.hotkey.bind({"cmd", "control", "option"}, "Up", function()
  moveWindow("full")
end)

return true
