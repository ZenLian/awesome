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

  -- {{{ TODO: systat: move to somewhere else
  local cpu = widget.iconic {
    icon = icons.cpu,
    desc = "N/A",
    fg = comp.wibar.cpu.fg,
  }
  awesome.connect_signal("service::cpu", function(result)
    local text = string.format("%s%%", result.usage)
    cpu.desc.markup = utils.markup.fg(text, comp.wibar.cpu.fg)
  end)

  local mem = widget.iconic {
    icon = icons.memory,
    desc = "N/A",
    fg = comp.wibar.memory.fg,
  }
  awesome.connect_signal("service::memory", function(result)
    local text = string.format("%s%%", result.perc)
    mem.desc.markup = utils.markup.fg(text, comp.wibar.memory.fg)
  end)

  local thermal = widget.iconic {
    icon = icons.thermal,
    desc = "N/A",
    fg = comp.wibar.thermal.fg,
  }
  awesome.connect_signal("service::thermal", function(result)
    local text = string.format("%s°C", result.thermal)
    thermal.desc.markup = utils.markup.fg(text, comp.wibar.thermal.fg)
  end)

  s.systat = wibox.widget {
    cpu,
    mem,
    thermal,
    layout = wibox.layout.fixed.horizontal,
    spacing = dpi(8),
  }
  --}}}

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
        s.systat,
        s.syscontrol,
        s.clock,
        s.layoutbox,
        s.right_toggler,
      },
    },
  }

  s.top_panel = panel
  return panel
end

return top_panel
