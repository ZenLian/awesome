local lgi = require("lgi")
local Gio, GLib = lgi.Gio, lgi.GLib
local gears = require("gears")
local utils = require("utils")
local Adapter = require("service.bluetooth.adapter")
local Device = require("service.bluetooth.device")

local M = {}

local INTERFACE = {
  PROPERTIES = "org.freedesktop.DBus.Properties",
  ADAPTER = "org.bluez.Adapter1",
  DEVICE = "org.bluez.Device1",
}

function M:find_parent(device_proxy)
  local property = device_proxy:get_cached_property("Adapter")
  if not property then
    return
  end

  for _, adapter in pairs(self.adapters) do
    local path = adapter.proxy:get_object_path()
    -- utils.debug(("parent(%s): %s\npath: %s"):format(type(property.value), property.value, path))
    if path == property.value then
      return adapter
    end
  end
end

local function on_interface_proxy_properties_changed(
  client,
  manager,
  object_proxy,
  interface_proxy,
  changed_properties,
  invalidated_properties
)
  if client.on_properties_changed then
    client.on_properties_changed()
  end
  local s = { object_proxy:get_object_path() .. " -> " .. interface_proxy:get_interface_name() }
  for name, var in changed_properties:pairs() do
    table.insert(s, string.format("%s: %s", name, var.value))
  end
  -- utils.debug(table.concat(s, "\n"), { title = "properties-changed" })
end

-- local function on_object_added(manager, object_proxy)
-- utils.debug(string.format("%s on %s", object_proxy:get_object_path(), client.name), { title = "object added" })
-- end

local function on_interface_added(client, manager, object, proxy)
  local name = proxy:get_interface_name()
  if name == INTERFACE.ADAPTER then
    client:add_adapter(proxy)
  elseif name == INTERFACE.DEVICE then
    client:add_device(proxy)
  end
end

local function on_interface_removed(client, manager, object, proxy)
  local name = proxy:get_interface_name()
  if name == INTERFACE.ADAPTER then
    client:remove_adapter(proxy)
  elseif name == INTERFACE.DEVICE then
    client:remove_device(proxy)
  end
end

M.new = function()
  local client = setmetatable({}, { __index = M })

  local manager = Gio.DBusObjectManagerClient.new_for_bus_sync(
    Gio.BusType.SYSTEM,
    Gio.DBusObjectManagerClientFlags.NONE,
    "org.bluez", -- well-known name
    "/" -- object path
  )

  if not manager or not manager.name_owner then
    error("failed on connecting DBus 'org.bluez'")
  end

  client.manager = manager

  -- manager.on_notify["name-owner"] = on_notify_name_owner
  -- manager.on_object_added = on_object_added
  -- manager.on_object_removed = on_object_removed
  manager.on_interface_added = function(...)
    on_interface_added(client, ...)
  end
  manager.on_interface_removed = function(...)
    on_interface_removed(client, ...)
  end
  manager.on_interface_proxy_properties_changed = function(...)
    on_interface_proxy_properties_changed(client, ...)
  end

  client:init_adapters()
  return client
end

function M:init_adapters()
  self.adapters = {}
  -- init objects
  local objs = self.manager:get_objects()
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

  -- utils.debug(string.format("%d adapters, %d devices", #adapter_proxies, #device_proxies))

  gears.table.map(function(proxy)
    self:add_adapter(proxy)
  end, adapter_proxies)
  gears.table.map(function(proxy)
    self:add_device(proxy)
  end, device_proxies)
end

function M:get_default_adapter()
  return self.adapter
end

function M:add_adapter(proxy)
  -- utils.debug("add_adapter: " .. proxy:get_object_path())
  local adapter = Adapter(proxy)
  table.insert(self.adapters, adapter)
  if not self.adapter then
    self.adapter = adapter
  end
end

function M:add_device(proxy)
  local adapter = self:find_parent(proxy)
  -- utils.debug("add device: " .. proxy:get_object_path())
  if not adapter then
    utils.error("parent not found")
    return
  end
  adapter:add_device(proxy)
end

function M:remove_adapter(proxy)
  local path = proxy:get_object_path()
  -- utils.debug("remove_adapter: " .. path)
  for i, adapter in ipairs(self.adapters) do
    if path == adapter.proxy:get_object_path() then
      table.remove(self.adapters, i)
      break
    end
  end
end

function M:remove_device(proxy)
  local adapter = self:find_parent(proxy)
  -- utils.debug("remove_device: " .. proxy:get_object_path())
  if not adapter then
    utils.error("remove_device: parent not found")
    return
  end
  adapter:remove_device(proxy)
end

return setmetatable(M, {
  __call = function()
    return M.new()
  end,
})
