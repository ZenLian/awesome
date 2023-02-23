local wibox = require("wibox")
local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi
local utils = require("utils")
local color = require("theme.sys.color")

local power_button = wibox.widget {
  {
    {
      widget = wibox.widget.textbox,
      font = utils.icon_font(18),
      text = "󰐥",
    },
    widget = wibox.container.margin,
    margins = dpi(10),
  },
  widget = wibox.container.background,
  fg = color.on_surface,
  bg = color.surface,
  shape = gears.shape.rounded_bar,
}

return wibox.widget {
  nil,
  nil,
  power_button,
  layout = wibox.layout.align.horizontal,
}
