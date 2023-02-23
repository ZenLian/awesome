local awful = require("awful")
local naughty = require("naughty")
local C = require("config")

-- {{{ misc stuff
require("menubar.utils").terminal = C.apps.terminal

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
  c:activate { context = "mouse_enter", raise = false }
end)

--- {{{ modules
local PREFIX = ... .. "."
local submodule = function(name)
  return require(PREFIX .. name)
end
submodule("keys")
submodule("client")
submodule("tags")
submodule("notification")
submodule("menu")
submodule("autostart")
submodule("titlebar")
submodule("wallpaper")
-- }}}
