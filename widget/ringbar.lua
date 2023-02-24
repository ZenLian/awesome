local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local utils = require("utils")
local theme = require("theme")

local new = function(args)
  args = args or {}
  local bar = wibox.widget {
    widget = wibox.container.radialprogressbar,
    paddings = dpi(15),
    value = args.value or 50,
    max_value = args.max_value or 100,
    min_value = args.min_value or 0,
    border_color = theme.palette.surface0,
    color = theme.palette.text,
    forced_width = args.size or dpi(60),
    forced_height = args.size or dpi(60),
    {
      widget = wibox.widget.imagebox,
      image = args.image,
    },
  }

  return bar
end

return new
