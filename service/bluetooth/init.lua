-- "service::bluetooth"
local utils = require("utils")
local service = require("service.core")
local bt = require("service.bluetooth.client")

local M = {}

local client

local function get_device_info(device)
  local info = {}

  local function read_property(name)
    local var = device:get_property(name)
    if var ~= nil then
      info[name] = var
    end
  end

  read_property("Address")
  if not info["Address"] then
    return info
  end
  read_property("Name")
  read_property("Paired")
  read_property("Connected")
  read_property("Alias")
  read_property("Class")
  read_property("Icon")
  read_property("Bonded")
  read_property("Trusted")
  read_property("Blocked")
  read_property("WakeAllowed")
  read_property("LegacyPairing")
  -- print_uuids(proxy);
  read_property("Modalias")
  read_property("ManufacturerData")
  read_property("ServiceData")
  read_property("RSSI")
  read_property("TxPower")
  read_property("AdvertisingFlags")
  read_property("AdvertisingData")

  return info
end

M.init = function()
  client = bt()
  client.on_properties_changed = function()
    M.update()
  end
end

M.get = function()
  -- utils.debug("call get")
  local result = {
    status = "off",
    devices = {},
    connected = {},
  }
  local adapter = client:get_default_adapter()

  -- powered
  local powered = adapter:get_property("Powered")
  if not powered then
    return result
  end
  result.status = "on"

  -- paired/connected devices
  -- utils.debug(string.format("%d devices", #adapter.devices))
  for _, device in ipairs(adapter.devices) do
    local info = get_device_info(device)
    local address, paired = info["Address"], info["Paired"]
    if address and paired then
      result.devices[address] = info
      -- table.insert(result.devices, device)
      if info["Connected"] then
        table.insert(result.connected, info)
      end
    end
  end

  if #result.connected > 0 then
    result.status = "connected"
  end

  return result
end

M.toggle = function(value)
  -- utils.debug(type(default_adapter))
  local adapter = client:get_default_adapter()
  local powered = adapter:get_property("Powered")
  if value == nil then
    value = not powered
  end
  if value ~= powered then
    utils.gdbus.set_property(adapter.proxy, "Powered", "b", not powered)
  end
end

return service.register(M, "bluetooth")
