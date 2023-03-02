local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local beautiful = require("beautiful")
local config = require("config")
local theme = require("theme")
local menubar = require("menubar")

local function lookup_icon(hint)
  return menubar.utils.lookup_icon(hint) or menubar.utils.lookup_icon(hint:lower())
end

local awesome_menu = {
  {
    "hotkeys",
    function()
      hotkeys_popup.show_help(nil, awful.screen.focused())
    end,
    theme.icons("keyboard"),
  },
  { "manual", config.apps.terminal .. " -e man awesome", theme.icons("help-box") },
  { "edit config", config.apps.editor .. " " .. awesome.conffile, theme.icons("file-edit") },
  { "restart", awesome.restart, theme.icons("restart") },
  {
    "quit",
    function()
      awesome.quit()
    end,
    theme.icons("logout"),
  },
}

local mainmenu = awful.menu {
  items = {
    { "awesome", awesome_menu, beautiful.awesome_icon },
    { "terminal", config.apps.terminal, lookup_icon("Alacritty") },
    { "browser", config.apps.browser, lookup_icon("microsoft-edge") },
    { "file explorer", config.apps.explorer, lookup_icon("Thunar") },
  },
}

return mainmenu
