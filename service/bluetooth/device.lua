local lgi = require("lgi")
local Gio = lgi.Gio
local utils = require("utils")

local M = {}

local function pair_reply(proxy, res, user_data)
  local _, err = proxy:call_finish(res)
  if err then
    utils.error(err)
    return
  end
end

function M.new(proxy)
  local device = {
    proxy = proxy,
    parent = nil, -- require set by adapter
  }

  return setmetatable(device, { __index = M })
end

function M:get_property(name)
  local var = self.proxy:get_cached_property(name)
  if not var then
    return
  end
  return var.value
end

function M:pair()
  self.proxy:call(
    "Pair",
    nil, --params
    Gio.DBusCallFlags.NONE,
    -1,
    nil, -- cancellable
    pair_reply -- callback
  )
end

return setmetatable(M, {
  __call = function(_, ...)
    return M.new(...)
  end,
})
