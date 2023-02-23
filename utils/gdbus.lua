local lgi = require("lgi")
local GLib, Gio = lgi.GLib, lgi.Gio
local utils = require("utils")

local M = {}

local function set_property_callback(proxy, res)
  local _, err = proxy:call_finish(res)
  if err then
    utils.error("%s")
  end
end

function M.set_property(proxy, name, dbus_type, value)
  local object = proxy:get_object()
  local property_proxy = object:get_interface("org.freedesktop.DBus.Properties")
  local var = GLib.Variant(dbus_type, value)
  local params = GLib.Variant("(ssv)", { proxy:get_interface_name(), name, var })
  property_proxy:call(
    "Set",
    params,
    Gio.DBusCallFlags.NONE,
    -1, -- timeout
    nil, -- cancellable
    set_property_callback
  )
end

return M
