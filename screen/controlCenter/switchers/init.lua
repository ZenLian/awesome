local wibox = require("wibox")
local theme = require("theme")
local switch = require(... .. ".switch")
local service = require("service")

local wifi = switch {
  icon = theme.icons.wifi,
  text = "Wi-fi",
  on_toggle = function(value)
    service.nm.toggle_wifi(value)
  end,
}

awesome.connect_signal("service::nm", function(devices)
  local DEVICE = require("config").device.wifi
  local dev = devices and devices[DEVICE]
  if not dev then
    return
  end
  if dev.state == "ACTIVATED" then
    wifi:set_enabled(true)
  else
    wifi:set_enabled(false)
  end
end)

local bluetooth = switch {
  icon = theme.icons.bluetooth,
  text = "Bluetooth",
  on_toggle = function(value)
    service.bluetooth.toggle(value)
  end,
}

awesome.connect_signal("service::bluetooth", function(result)
  local status = result.status
  if status == "off" then
    bluetooth:set_enabled(false)
  else
    bluetooth:set_enabled(true)
  end
end)

local placeholder = switch {
  icon = theme.icons.switch_on,
  text = "switch",
}

return wibox.widget {
  wifi,
  bluetooth,
  placeholder,
  layout = wibox.layout.flex.horizontal,
  spacing = theme.comp.controlhub.spacing,
}
