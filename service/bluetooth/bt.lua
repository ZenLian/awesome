-- "service::bluetooth"
local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local utils = require("utils")
local service = require("service.core")
local lgi = require("lgi")
local Gio, GLib = lgi.Gio, lgi.GLib

local M = {}

local adapters = {}
local default_adapter
local manager

local INTERFACE = {
  PROPERTIES = "org.freedesktop.DBus.Properties",
  ADAPTER = "org.bluez.Adapter1",
  DEVICE = "org.bluez.Device1",
}

local function add_adapter(proxy)
  local adapter = {
    proxy = proxy,
    devices = {},
  }
  table.insert(adapters, adapter)
  if not default_adapter then
    default_adapter = adapter
  end
end

local function remove_adapter() end

local function find_parent(proxy)
  local property = proxy:get_cached_property("Adapter")
  if not property then
    return
  end

  for _, adapter in ipairs(adapters) do
    local path = adapter.proxy:get_object_path()
    -- utils.debug(("parent(%s): %s\npath: %s"):format(type(property.value), property.value, path))
    if path == property.value then
      return adapter
    end
  end
end

local function add_device(proxy)
  local adapter = find_parent(proxy)
  if not adapter then
    utils.error("parent not found")
    return
  end

  table.insert(adapter.devices, proxy)
end

local function manage_objects()
  local objs = manager:get_objects()

  local adapter_proxies = {}
  local device_proxies = {}
  for _, obj in ipairs(objs) do
    for _, proxy in ipairs(obj:get_interfaces()) do
      local name = proxy:get_interface_name()
      if name == INTERFACE.ADAPTER then
        table.insert(adapter_proxies, proxy)
      elseif name == INTERFACE.DEVICE then
        table.insert(device_proxies, proxy)
      end
    end
  end

  gears.table.map(add_adapter, adapter_proxies)
  gears.table.map(add_device, device_proxies)
end

local function get_property(proxy, interface, name)
  local property_proxy = proxy:get_interface(INTERFACE.PROPERTIES)
  local params = GLib.Variant("(ss)", { interface, name })
  local var, err = property_proxy:call_sync(
    "Get",
    params,
    Gio.DBusCallFlags.NONE,
    -1, -- timeout
    nil -- cancellable
  )

  if var == nil or #var == 0 then
    return
  end

  return var[1].value
end

local function set_property(proxy, name, value)
  -- local adapter = find_parent(proxy)
  -- if not adapter then
  --   utils.error(string.format("parent not found: %s", proxy:get_interface_name()))
  --   return
  -- end
  local object = proxy:get_object()
  local property_proxy = object:get_interface(INTERFACE.PROPERTIES)
  local params = GLib.Variant("(ssv)", { proxy:get_interface_name(), name, value })
  local ret = property_proxy:call_sync(
    "Set",
    params,
    Gio.DBusCallFlags.NONE,
    -1, -- timeout
    nil, -- cancellable
    nil -- error
  )
  --
  if ret == nil then
    utils.error("fail on 'Set' call")
  end
end

local function get_device_info(proxy)
  local device = {}

  local function read_property(name)
    local var = proxy:get_cached_property(name)
    if var then
      device[name] = var.value
    end
  end

  read_property("Address")
  if not device["Address"] then
    return device
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

  return device
end

local function on_notify_name_owner(client, spec)
  -- local name = spec.name
  -- local value = spec.value
  -- utils.debug(string.format("%s: %s", name, value), { title = "on_notify" })
  -- utils.debug(string.format("%s", client:get_name_owner()), { title = "on_notify_name_owner" })
end

local function on_object_added(client, object_proxy)
  -- utils.debug(string.format("%s on %s", object_proxy:get_object_path(), client.name), { title = "object added" })
end

local function on_object_removed(client, object_proxy)
  -- utils.debug(string.format("%s on %s", object_proxy:get_object_path(), client.name), { title = "object removed" })
end

local function on_interface_added(_, proxy)
  local name = proxy:get_interface_name()
  if name == INTERFACE.ADAPTER then
    add_device(proxy)
  end
end

local function on_properties_changed(client, object_proxy, interface_proxy, changed_properties, invalidated_properties)
  local s = { object_proxy:get_object_path() .. " -> " .. interface_proxy:get_interface_name() }
  for name, var in changed_properties:pairs() do
    table.insert(s, string.format("%s: %s", name, var.value))
  end
  utils.debug(table.concat(s, "\n"), { title = "properties-changed" })

  M.update()
end

-- {{{ Client
local Client = {}

Client.new = function()
  local client = {}
  client.manager = Gio.DBusObjectManagerClient.new_for_bus_sync(
    Gio.BusType.SYSTEM,
    Gio.DBusObjectManagerClientFlags.NONE,
    "org.bluez",
    "/"
  )
  if not client.manager or not client.manager.name_owner then
    return
  end
  return setmetatable(client, { __index = Client })
end

setmetatable(Client, {
  __call = function()
    return Client.new()
  end,
})
-- Client }}}

M.init = function()
  -- one and only client
  local bus = Gio.bus_get_sync(Gio.BusType.SYSTEM)
  manager = Gio.DBusObjectManagerClient.new_sync(
    bus,
    Gio.DBusObjectManagerClientFlags.NONE,
    "org.bluez", -- well-known name
    "/" -- object path
  )
  if not manager or not manager.name_owner then
    utils.error("failed on connecting DBus 'org.bluez'")
    return
  end

  manage_objects()

  -- manager.on_notify["name-owner"] = on_notify_name_owner
  manager.on_interface_proxy_properties_changed = on_properties_changed
  -- manager.on_object_added = on_object_added
  -- manager.on_object_removed = on_object_removed
  -- manager.on_interface_added = on_interface_added
  -- manager.on_interface_removed = on_interface_removed
end

M.get = function()
  -- utils.debug("call get")
  local result = {
    status = "off",
    devices = {},
    connected = {},
  }

  -- powered
  local powered = default_adapter.proxy:get_cached_property("Powered")
  if not powered or not powered.value then
    return result
  end
  result.status = "on"

  -- paired/connected devices
  for _, proxy in ipairs(default_adapter.devices) do
    local device = get_device_info(proxy)
    local address, paired = device["address"], device["Paired"]
    if address and paired then
      result.devices[address] = device
      -- table.insert(result.devices, device)
      if device["Connected"] then
        table.insert(result.connected, device)
      end
    end
  end

  if #result.connected > 0 then
    result.status = "connected"
  end

  return result
end

M.toggle = function(src)
  -- utils.debug(type(default_adapter))
  local var = default_adapter.proxy:get_cached_property("Powered")
  if not var then
    return
  end
  set_property(default_adapter.proxy, "Powered", GLib.Variant("b", not var.value))
  -- M.update(src)
end

return service.register(M, "bluetooth", 0)
