-- a button redises in top_panel, to toggle right_panel,
local wibox = require("wibox")
local awful = require("awful")
local icons = require("theme.icons")
local theme = require("theme")

local factory = function()
  local toggler = wibox.widget {
    widget = wibox.widget.imagebox,
    id = "icon",
    image = icons("info-center"),
  }

  toggler:buttons {
    awful.button({}, 1, function()
      awful.screen.focused().right_panel:toggle()
    end),
  }

  local old_cursor, old_wibox
  toggler:connect_signal("mouse::enter", function()
    local w = mouse.current_wibox
    if w then
      old_cursor, old_wibox = w.cursor, w
      w.cursor = "hand1"
    end
  end)
  toggler:connect_signal("mouse::leave", function()
    -- toggler.bg = beautiful.leave_event
    if old_wibox then
      old_wibox.cursor = old_cursor
      old_wibox = nil
    end
  end)

  return toggler
end

return factory
