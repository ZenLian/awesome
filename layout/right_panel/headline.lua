local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local icons = require("theme.icons")
local utils = require("utils")
local theme = require("theme")
local widget = require("widget")
local config = require("config")

local power = wibox.widget {
  widget = wibox.container.background,
  shape = utils.shape.rrect(32),
  bg = theme.palette.base,
  forced_width = dpi(32),
  forced_height = dpi(32),
  {
    widget = wibox.container.margin,
    margins = dpi(4),
    {
      widget = wibox.widget.imagebox,
      image = icons("power"),
    },
  },
}

power:buttons {
  awful.button({}, 1, function()
    awesome.emit_signal("layout::exit_screen::show")
  end),
}

return wibox.widget {
  layout = wibox.layout.fixed.horizontal,
  power,
}
