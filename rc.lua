pcall(require, "luarocks.loader")
local naughty = require("naughty")
local awful = require("awful")
require("awful.autofocus")

-- {{{ mods path
local cfg_path = require("gears").filesystem.get_configuration_dir()
package.path = cfg_path .. "mods/?.lua;" .. cfg_path .. "mods/?/init.lua;" .. package.path
-- }}}

-- {{{ Error handling
-- NOTE: must put before other config
naughty.connect_signal("request::display_error", function(message, startup)
  naughty.notification {
    urgency = "critical",
    title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
    message = message,
  }
end)
-- }}}

awful.util.shell = "bash"

require("theme").init()
require("modules")
require("layout")
require("service").run()
