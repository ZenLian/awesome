local awful = require("awful")
local naughty = require("naughty")
local menubar = require("menubar")
local beautiful = require("beautiful")
local color = require("theme.sys.color")
local ruled = require("ruled")

local M = {}

-- {{{ Notification rules
ruled.notification.connect_signal("request::rules", function()
  -- All notifications will match this rule.
  ruled.notification.append_rule {
    rule = {},
    properties = {
      screen = awful.screen.preferred,
      implicit_timeout = 5,
    },
  }

  ruled.notification.append_rule {
    rule = { urgency = "critical" },
    properties = {
      timeout = 0,
      bg = color.error,
      fg = color.on_error,
    },
  }
end)
-- }}}

-- XDG icon lookup
naughty.connect_signal("request::icon", function(n, context, hints)
  if context ~= "app_icon" then
    return
  end
  local path = menubar.utils.lookup_icon(hints.app_icon) or menubar.utils.lookup_icon(hints.app_icon:lower())
  n.icon = path or beautiful.awesome_icon
end)

naughty.connect_signal("request::display", function(n)
  naughty.layout.box { notification = n }
end)

-- DEBUG keymap
local modifier = { "Mod4", "Mod1" }
awful.keyboard.append_global_keybindings {
  awful.key(modifier, "j", function()
    naughty.notification {
      urgency = "critical",
      title = "critical",
      text = "error text",
      icon = beautiful.awesome_icon,
    }
  end),
  awful.key(modifier, "k", function()
    naughty.notification {
      urgency = "normal",
      title = "normal",
      text = "normal long long long long long long long long long long long long long long long long text",
      icon = beautiful.awesome_icon,
    }
  end),
  awful.key(modifier, "l", function()
    naughty.notification {
      urgency = "low",
      title = "low",
      text = "low text",
      icon = beautiful.awesome_icon,
    }
  end),
}

return M
