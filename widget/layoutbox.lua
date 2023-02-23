local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local buttons = {
  awful.button({}, 1, function() -- left click
    awful.layout.inc(1)
  end),
  awful.button({}, 3, function() -- right click
    awful.layout.inc(-1)
  end),
  awful.button({}, 4, function() -- scroll up
    awful.layout.inc(1)
  end),
  awful.button({}, 5, function() -- scroll down
    awful.layout.inc(-1)
  end),
}

local factory = function(s)
  local layoutbox = wibox.widget {
    widget = awful.widget.layoutbox,
    screen = s,
    buttons = buttons,
  }

  return layoutbox
end

return factory
