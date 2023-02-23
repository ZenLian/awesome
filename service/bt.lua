-- WARN: deprecated, use service.bluetooth instead
local awful = require("awful")
local service = require("service.core")
-- TODO: use lgi.Gio.DBus_*

local M = {}

local function parse_device_info(output, device)
  if not output then
    return {}
  end
  for k, v in string.gmatch(output, "([%a]+):[%s]+([^\n]+)") do
    if k ~= "UUID" then
      device[k] = v
    else
      if not device.UUID then
        device.UUID = {}
      end
      local name, uuid = v:match("([^%(]+)%(([%x%-]+)%)")
      -- trailing spaces
      name = name:gsub("[%s]*$", "")
      device.UUID[uuid] = name
    end
  end
  return device
end

M.get = function()
  local result = {
    status = "off",
    devices = {},
    connected = {},
  }

  -- powered
  local f = io.popen("bluetoothctl show")
  if f then
    local output = f:read("*a")
    local powered = output:match("Powered: ([%l]+)")
    if powered == "yes" then
      result.status = "on"
    end
    f:close()
  end
  if result.status ~= "on" then
    return result
  end

  -- paired devices
  f = io.popen("bluetoothctl devices Paired")
  if f then
    for line in f:lines() do
      local addr, name = line:match("Device[%s]+([%x:]+)[%s]+(.*)")
      result.devices[addr] = {
        addr = addr,
        name = name,
      }
    end
    f:close()
  end

  -- device info
  for addr, device in pairs(result.devices) do
    f = io.popen(("bluetoothctl info %s"):format(addr))
    local output
    if f then
      -- skip first line
      f:read("l")
      output = f:read("a")
      f:close()
    end
    parse_device_info(output, device)
    -- connected devices
    if device["Connected"] == "yes" then
      table.insert(result.connected, addr)
    end
  end

  if #result.connected > 0 then
    result.status = "connected"
  end

  return result
end

return service.register(M, "bt", 5)
