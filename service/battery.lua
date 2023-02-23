-- "service::battery"
-- , src(string)

-- https://lazka.github.io/pgi-docs/#UPowerGlib-1.0
local upower = require("lgi").require("UPowerGlib")
local naughty = require("naughty")
local service = require("service.core")

local M = {}

local DEVICE_PATH = "/org/freedesktop/UPower/devices/battery_BAT0"

local get_device = function(path)
  local devices = upower.Client():get_devices()
  for _, device in ipairs(devices) do
    if device:get_object_path() == path then
      return device
    end
  end
end

M.init = function()
  M.device = get_device(DEVICE_PATH)
  if not M.device then
    naughty.notify {
      title = "upower device not found",
      text = DEVICE_PATH,
    }
    return
  end
  -- upower event notify
  M.device.on_notify = function(_)
    M.update("upower")
  end
end

M.get = function()
  local device = M.device
  local result = {
    state = "N/A",
    percentage = 0,
    time = "N/A",
    health = "N/A",
    rate = "N/A",
  }

  if not device.is_present then
    return result
  end

  -- charging/discharging rate
  result.rate = device.energy_rate
  result.percentage = device.percentage
  result.state = device.state_to_string(device.state)
  result.time = "N/A"
  result.health = math.floor(device.energy_full / device.energy_full_design * 100)

  -- calculate time
  local seconds_left
  if device.state == upower.DeviceState.CHARGING then
    seconds_left = device.time_to_full
  elseif device.state == upower.DeviceState.DISCHARGING then
    seconds_left = device.time_to_empty
  else
    return result
  end
  local minutes_left = seconds_left // 60
  local hours_left = minutes_left // 60
  minutes_left = minutes_left % 60
  result.time = string.format("%02d:%02d", hours_left, minutes_left)

  return result
end

return service.register(M, "battery")
