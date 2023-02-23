local naughty = require("naughty")

local M = {}

function M.font(size)
  local config = require("config")
  size = size or config.theme.font.size
  return string.format("%s %d", config.theme.font.family, size)
end

function M.icon_font(size)
  local config = require("config")
  size = size or config.theme.icon_font.size
  return string.format("%s %d", config.theme.icon_font.family, size)
end

M.debug = function(text, args)
  local opts = {
    urgency = "low",
    title = "<span><b>Debug</b></span>",
    text = text,
    timeout = 0,
    -- border_color = ,
  }
  opts = M.table.extend(opts, args)
  naughty.notification(opts)
end

M.error = function(text, args)
  local opts = {
    urgency = "critical",
    text = text,
  }
  opts = M.table.extend(opts, args)
  naughty.notification(opts)
end

local PREFIX = ... .. "."

return setmetatable(M, {
  __index = function(self, key)
    local module = require(PREFIX .. key)
    rawset(self, key, module)
    return module
  end,
})
