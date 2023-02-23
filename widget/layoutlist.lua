------------------------
-- Layout popup widget
------------------------

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local utils = require("utils")

local factory = function()
  local layoutlist = awful.widget.layoutlist {
    source = awful.widget.layoutlist.source.default_layouts,
    spacing = dpi(24),
    base_layout = wibox.widget {
      spacing = dpi(24),
      forced_num_cols = 3,
      layout = wibox.layout.grid.vertical,
    },
    widget_template = {
      {
        {
          id = "icon_role",
          forced_height = dpi(68),
          forced_width = dpi(68),
          widget = wibox.widget.imagebox,
        },
        margins = dpi(24),
        widget = wibox.container.margin,
      },
      id = "background_role",
      forced_width = dpi(68),
      forced_height = dpi(68),
      shape = utils.shape.rrect(8),
      widget = wibox.container.background,
    },
  }

  local layout_popup = awful.popup {
    widget = wibox.widget {
      -- {
      layoutlist,
      margins = dpi(24),
      widget = wibox.container.margin,
      -- },
      -- bg = beautiful.bg_normal .. "88",
      -- widget = wibox.container.background,
    },
    placement = awful.placement.centered,
    ontop = true,
    visible = false,
    shape = utils.shape.rrect(beautiful.rounded),
    bg = beautiful.bg_normal .. "88",
  }

  return layout_popup
end

return factory
