local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local icons = require("theme.icons")
local utils = require("utils")
local theme = require("theme")
local config = require("config")
local naughty = require("naughty")

local notiflist = wibox.widget {
  widget = naughty.list.notifications,
  base_layout = wibox.widget {
    layout = wibox.layout.fixed.vertical,
    spacing = dpi(10),
  },
  widget_template = {
    widget = wibox.container.background,
    bg = theme.palette.base,
    shape = utils.shape.rrect(5),
    {
      widget = wibox.container.margin,
      margins = dpi(12),
      {
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(10),
        fill_space = true,
        naughty.widget.icon,
        {
          layout = wibox.layout.fixed.vertical,
          spacing = dpi(3),
          widget = naughty.widget.title,
          spacing_widget = wibox.widget {
            widget = wibox.widget.separator,
            orientation = "horizontal",
            color = theme.palette.crust,
            span_ratio = 1,
          },
          naughty.widget.message,
        },
      },
    },
  },
}

return notiflist
