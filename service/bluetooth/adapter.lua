local utils = require("utils")
local Device = require("service.bluetooth.device")

local M = {}

local function on_properties_changed(adapter, proxy, changed_properties, invalidated_properties)
  -- utils.debug(string.format("%s\n", proxy:get_interface_name()))
  if adapter.on_properties_changed then
    adapter.on_properties_changed(proxy, changed_properties, invalidated_properties)
  end
end

local function on_signal(proxy, sender, signal, params)
  utils.debug(string.format("%s\nrecv signal '%s' from '%s'", proxy:get_interface_name(), signal, sender))
end

M.new = function(proxy)
  local adapter = {
    proxy = proxy,
    devices = {},
  }

  -- proxy.on_g_properties_changed = function(...)
  --   on_properties_changed(adapter, ...)
  -- end
  -- proxy.on_g_signal = on_signal

  return setmetatable(adapter, { __index = M })
end

function M:add_device(proxy)
  local device = Device(proxy)
  device.parent = self
  table.insert(self.devices, device)
end

function M:remove_device(proxy)
  local path = proxy:get_object_path()
  for i, device in ipairs(self.devices) do
    if path == device.proxy:get_object_path() then
      table.remove(self.devices, i)
      break
    end
  end
end

function M:get_property(name)
  local var = self.proxy:get_cached_property(name)
  if not var then
    return
  end
  return var.value
end

function M:set_property(name, dbus_type, value)
  utils.gdbus.set_property(self.proxy, name, dbus_type, value)
end

return setmetatable(M, {
  __call = function(_, ...)
    return M.new(...)
  end,
})
