-- "service::network"
-- keys are network interface names, e.g. wlan0, eth0, lo
-- * wlan0
--   * state(string)
--   * wifi(table) only for wlan interface
--     * strength(number)
--       signal quality in percentage
local lgi = require("lgi")
local NM, GLib = lgi.NM, lgi.GLib
local service = require("service.core")

local M = {
  devices = {},
}

local client

function M.init()
  client = NM.Client()
  local function notify()
    M.update()
  end
  client.on_active_connection_added = notify
  client.on_active_connection_removed = notify
  client.on_connection_added = notify
  client.on_connection_removed = notify
  client.on_device_added = notify
  client.on_device_removed = notify
end

M.get = function()
  local result = {}

  -- list devices
  local devs = client:get_devices()
  for _, dev in ipairs(devs) do
    local info = {}
    local name = dev:get_iface()
    local state = dev:get_state()

    info.name = name
    info.state = state
    info.type = dev:get_device_type()

    -- -- total tx/rx bytes
    -- local tx = tonumber(utils.io.first_line(string.format("%s/statistics/tx_bytes", sysnet)) or 0)
    -- local rx = tonumber(utils.io.first_line(string.format("%s/statistics/rx_bytes", sysnet)) or 0)
    -- info.tx, info.rx = tx, rx
    --
    -- -- calculate net speed
    -- local now = os.time()
    -- if not M.devices[name] then
    --   info.up, info.down = 0, 0
    -- else
    --   local interval = now - M.devices[name].time
    --   if interval <= 0 then
    --     interval = 1
    --   end
    --   local up = (tx - M.devices[name].tx) / interval
    --   local down = (rx - M.devices[name].rx) / interval
    --
    --   -- dev.up = string.format("%.1f", up)
    --   -- dev.down = string.format("%.1f", down)
    --   info.up, info.down = up, down
    -- end
    -- info.time = now

    -- wifi info
    info.wifi = nil
    if info.type == "WIFI" then
      info.wifi = {}
      local ap = dev:get_active_access_point()
      if ap then
        local ssid = ap:get_ssid()
        local ap_name = ssid and NM.utils_ssid_to_utf8(ssid:get_data()) or ""
        info.wifi.name = ap_name
        info.wifi.strength = ap:get_strength()
      end
    end
    info.dev = dev

    result[name] = info
  end

  -- -- wifi
  -- for _, line in ipairs(utils.io.get_lines("/proc/net/wireless", 3)) do
  --   local name, level = string.match(line, "([%w]+):[%s]+[%d]+[%s]+[%d]+%.[%s]+(%-[%d]+)%.")
  --   -- level to signal: -100dBm=>0%, -50dBm=>100%
  --   local signal = 200 + tonumber(level) * 2
  --   result[name].wifi = {
  --     level = tonumber(level),
  --     signal = signal,
  --   }
  -- end

  -- cache it
  M.devices = result
  return result
end

function M.toggle_wifi(value)
  local enabled = client:wireless_get_enabled()
  if value == nil then
    value = not enabled
  end
  if value ~= enabled then
    client:dbus_set_property(NM.DBUS_PATH, NM.DBUS_INTERFACE, "WirelessEnabled", GLib.Variant("b", value), -1)
  end
end

return service.register(M, "nm", 5)
