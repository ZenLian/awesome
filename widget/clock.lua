local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local utils = require("utils")
local theme = require("theme")

local factory = function(s)
  local clock = wibox.widget {
    widget = wibox.widget.textclock,
    format = "%H:%M",
    refresh = 1,
  }

  clock = wibox.widget {
    clock,
    -- margins = dpi(8),
    -- up = dpi(8),
    -- down = dpi(8),
    widget = wibox.container.margin,
  }

  awful.tooltip {
    objects = { clock },
    mode = "outside",
    preferred_positions = { "right", "left", "top", "bottom" },
    preferred_alignments = { "middle", "front", "back" },
    -- margin_leftright = dpi(8),
    -- margin_topbottom = dpi(8),
    timer_function = function()
      return os.date("    %T\n%Y.%m.%d %A")
    end,
  }

  local transparent = "#00000000"
  s.month_calendar = awful.widget.calendar_popup.month {
    start_sunday = false,
    spacing = dpi(5),
    font = utils.font(11),
    long_weekdays = true,
    margin = dpi(5),
    screen = s,
    style_month = {
      border_width = dpi(0),
      bg_color = beautiful.background,
      padding = dpi(20),
      -- shape = function(cr, width, height)
      --   gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, dpi(8))
      -- end,
    },
    style_header = {
      border_width = 0,
      bg_color = transparent,
    },
    style_weekday = {
      border_width = 0,
      bg_color = transparent,
    },
    style_normal = {
      border_width = 0,
      bg_color = transparent,
    },
    style_focus = {
      border_width = dpi(1),
      border_color = theme.palette.blue,
      bg_color = theme.palette.surface0,
      fg_color = theme.palette.blue,
      padding = dpi(2),
      shape = function(cr, width, height)
        gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, dpi(3))
      end,
    },
  }

  s.month_calendar:attach(clock, "tr", {
    on_pressed = true,
    on_hover = false,
  })

  return clock
end

return factory
