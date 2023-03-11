-- a button redises in top_panel, to toggle right_panel,
local wibox = require("wibox")
local awful = require("awful")
local icons = require("theme.icons")
local theme = require("theme")

local factory = function(s)
  local switcher = wibox.widget {
    widget = wibox.widget.imagebox,
    image = icons("wallpaper"),
  }

  switcher:buttons {
    awful.button({}, 1, function()
      screen.emit_signal("request::wallpaper", s)
    end),
  }

  awful.tooltip {
    objects = { switcher },
    timer_function = function()
      return "Change Wallpaper"
    end,
  }

  local old_cursor, old_wibox
  switcher:connect_signal("mouse::enter", function()
    local w = mouse.current_wibox
    if w then
      old_cursor, old_wibox = w.cursor, w
      w.cursor = "hand1"
    end
  end)
  switcher:connect_signal("mouse::leave", function()
    -- toggler.bg = beautiful.leave_event
    if old_wibox then
      old_wibox.cursor = old_cursor
      old_wibox = nil
    end
  end)

  return switcher
end

return factory
