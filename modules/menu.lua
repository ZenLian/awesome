local awful = require("awful")
local beautiful = require("beautiful")
local config = require("config")
local theme = require("theme")

local awesome_menu = {
  {
    "hotkeys",
    function()
      awful.hotkeys_popup.show_help(nil, awful.screen.focused())
    end,
  },
  { "manual", config.apps.terminal .. "-e man awesome" },
  { "edit config", config.apps.terminal .. " -e " .. config.apps.editor .. awesome.conffile },
  { "restart", awesome.restart },
  {
    "quit",
    function()
      awesome.quit()
    end,
  },
}

local apps_menu = {
  { "web", config.apps.browser, theme.icons.web },
  { "files", config.apps.explorer, theme.icons.files },
}

local mainmenu = awful.menu {
  items = {
    { "awesome", awesome_menu, beautiful.awesome_icon },
    { "open terminal", config.apps.terminal, theme.icons.get_mdi("console-line", theme.comp.menu.icon.fg) },
    { "apps", apps_menu },
  },
}

return mainmenu
