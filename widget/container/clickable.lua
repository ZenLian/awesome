local wibox = require("wibox")

local factory = function(widget)
  local clickable = wibox.widget {
    widget = wibox.container.background,
    widget,
  }

  local old_cursor, old_wibox
  clickable:connect_signal("mouse::enter", function()
    local w = mouse.current_wibox
    if w then
      old_cursor, old_wibox = w.cursor, w
      w.cursor = "hand1"
    end
  end)
  clickable:connect_signal("mouse::leave", function()
    -- clickable.bg = beautiful.leave_event
    if old_wibox then
      old_wibox.cursor = old_cursor
      old_wibox = nil
    end
  end)

  return clickable
end

return factory
