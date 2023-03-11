local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local widget = require("widget")
local icons = require("theme.icons")
local utils = require("utils")
local comp = require("theme.comp")
local config = require("config")

local top_panel = function(s)
  local panel = awful.wibar {
    screen = s,
    visible = true,
    ontop = false,
    type = "dock",
    height = dpi(config.layout.top_panel.height),
    bg = beautiful.bg_normal,
    fg = beautiful.fg_normal,
  }

  s.taglist = widget.taglist(s)
  s.tasklist = widget.tasklist(s)

  s.volume = widget.volume()
  s.battery = widget.battery()
  s.wifi = widget.wifi()
  s.bluetooth = widget.bluetooth()
  s.syscontrol = wibox.widget {
    s.volume,
    s.bluetooth,
    s.wifi,
    s.battery,
    layout = wibox.layout.fixed.horizontal,
    spacing = dpi(8),
  }

  s.clock = widget.clock(s)
  s.systray = wibox.widget {
    widget = wibox.widget.systray,
    reverse = true,
    screen = "primary",
  }

  s.layoutbox = widget.layoutbox(s)
  s.right_toggler = widget.right_toggler()
  s.wallpaper_switcher = widget.wallpaper_switcher(s)

  panel:setup {
    layout = wibox.layout.align.horizontal,
    -- expand = "none",
    {
      layout = wibox.layout.fixed.horizontal,
      s.taglist,
    },
    {
      layout = wibox.layout.fixed.horizontal,
      s.tasklist,
    },
    {
      widget = wibox.container.margin,
      margins = dpi(6),
      {
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(6),
        s.systray,
        s.syscontrol,
        s.clock,
        s.wallpaper_switcher,
        s.layoutbox,
        s.right_toggler,
      },
    },
  }

  s.top_panel = panel
  return panel
end

return top_panel
