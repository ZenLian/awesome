local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")
local utils = require("utils")
local theme = require("theme")
local service = require("service")
local config = require("config")

-- args
local fg = theme.palette.lavender
local device = config.device.wifi

local factory = function()
  local wifi = wibox.widget {
    widget = wibox.widget.textbox,
    font = utils.icon_font(),
    markup = theme.icons.wifi_off,
  }

  awesome.connect_signal("service::nm", function(devices)
    local dev = devices and devices[device]
    if not dev then
      return
    end
    if dev.state == "ACTIVATED" then
      local icon = theme.icons.get_wifi(dev.wifi.strength or 100)
      wifi:set_markup(utils.markup.fg(icon, fg))
    else
      local icon = theme.icons.wifi_off
      wifi:set_markup(utils.markup.fg(icon, fg))
    end
  end)

  awful.tooltip {
    ontop = true,
    objects = { wifi },
    timer_function = function()
      local dev = service.nm.devices[device]
      local text = {}
      table.insert(text, string.format("%s: %s", dev.name, dev.state))
      table.insert(text, string.format("%s(%s)", dev.wifi.name, dev.wifi.strength))
      -- text[#text + 1] = "bitrate" --string.format("%s bit/s", dev.wifi.bitrate)
      return table.concat(text, "\n")
    end,
  }

  wifi:buttons {
    awful.button({}, "1", function()
      awful.spawn(config.apps.terminal .. " -e nmtui-connect")
    end),
  }

  return wifi
end

return factory
