local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local service = require("service")
local menubar = require("menubar")
local menu = require("modules.menu")
local C = require("config")

local modkey = C.keys.modkey or "Mod4"
local ctrl = "Control"
local shift = "Shift"
-- local alt = "Mod1"

-- {{{ awesome stuff
awful.keyboard.append_global_keybindings {
  awful.key({ modkey }, "F1", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
  awful.key({ modkey, ctrl }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
  awful.key({ modkey, ctrl }, "q", function()
    awesome.emit_signal("layout::exit_screen::show")
  end, { description = "quit awesome", group = "awesome" }),
  awful.key({ modkey, ctrl }, "p", function()
    menu:toggle()
  end, { description = "toggle menu", group = "awesome" }),
  awful.key({ modkey }, "r", function()
    menubar.show()
  end, { description = "show the menubar", group = "launcher" }),
  awful.key({ modkey }, "n", function()
    local screen = awful.screen.focused()
    screen.right_panel:toggle()
  end, { description = "toggle right_panel", group = "awesome" }),
}
-- }}}

local rofi_config = "$HOME/.config/awesome/extra/rofi/config.rasi"
-- {{{ launchers
awful.keyboard.append_global_keybindings {
  awful.key({ modkey }, "Return", function()
    awful.spawn(C.apps.terminal)
  end, { description = "terminal", group = "launcher" }),

  awful.key({ modkey }, " ", function()
    awful.spawn(C.apps.terminal .. " --class=Floaterm")
  end, { description = "float terminal", group = "launcher" }),

  awful.key({ modkey }, "b", function()
    awful.spawn(C.apps.browser)
  end, { description = "web browser", group = "launcher" }),

  awful.key({ modkey }, "e", function()
    awful.spawn(C.apps.explorer)
  end, { description = "file explorer", group = "launcher" }),

  -- TODO: configurable
  -- awful.key({ modkey }, "p", function()
  --   awful.spawn(C.apps.launcher)
  -- end, { description = "rofi drun", group = "launcher" }),
  awful.key({ modkey }, "p", function()
    awful.spawn.with_shell(("rofi -show combi -config %s -dpi %s"):format(rofi_config, awful.screen.focused().dpi))
  end, { description = "rofi run", group = "launcher" }),
  awful.key({ modkey }, "w", function()
    awful.spawn.with_shell(("rofi -show window -config %s -dpi %s"):format(rofi_config, awful.screen.focused().dpi))
  end, { description = "rofi window", group = "launcher" }),

  -- TODO: lauch colorpicker, screenshoter
}
-- }}}

-- {{{ fn keys(media control)
awful.keyboard.append_global_keybindings {
  awful.key({}, "XF86MonBrightnessUp", function()
    service.brightness.set("15%+")
  end, { description = "increase brightness", group = "control" }),

  awful.key({}, "XF86MonBrightnessDown", function()
    service.brightness.set("15%-")
  end, { description = "decrease brightness", group = "control" }),

  -- awful.key({}, "Print", function()
  -- 	awful.util.spawn(home_var .. "/.scripts/ss area", false)
  -- end, { description = "screenshot", group = "control" }),

  awful.key({}, "XF86AudioRaiseVolume", function()
    service.volume.set("5%+")
  end, { description = "increase volume", group = "control" }),

  awful.key({}, "XF86AudioLowerVolume", function()
    service.volume.set("5%-")
  end, { description = "decrease volume", group = "control" }),

  awful.key({}, "XF86AudioMute", function()
    service.volume.set("toggle")
  end, { description = "mute volume", group = "control" }),
}
-- }}}

-- {{{ screenshot
-- TODO: config
awful.keyboard.append_global_keybindings {
  awful.key({}, "Print", function()
    awful.spawn("flameshot gui")
  end, { description = "screenshot", group = "control" }),
  awful.key({ modkey }, "Print", function()
    awful.spawn.with_shell("flameshot full --clipboard")
  end, { description = "screenshot fullscreen", group = "control" }),
  awful.key({}, "XF86ScreenSaver", function()
    awful.spawn.with_shell("flameshot launcher")
  end, { description = "screenshot launcher", group = "control" }),
}
-- }}}

--- {{{ tags
awful.keyboard.append_global_keybindings {

  -- last tag
  awful.key({ modkey }, "`", awful.tag.history.restore, { description = "go back", group = "tag" }),

  -- prev/next tag
  awful.key({ modkey, ctrl }, "h", awful.tag.viewprev, { description = "view previous", group = "tag" }),
  awful.key({ modkey, ctrl }, "l", awful.tag.viewnext, { description = "view next", group = "tag" }),

  -- view tag only
  awful.key {
    modifiers = { modkey },
    keygroup = awful.key.keygroup.NUMROW,
    description = "view tag only",
    group = "tag",
    on_press = function(index)
      local screen = awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
        tag:view_only()
      end
    end,
  },

  -- toggle tag display
  awful.key {
    modifiers = { modkey, ctrl },
    keygroup = awful.key.keygroup.NUMROW,
    description = "toggle tag",
    group = "tag",
    on_press = function(index)
      local screen = awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
        awful.tag.viewtoggle(tag)
      end
    end,
  },

  -- Move client to tag.
  awful.key {
    modifiers = { modkey, shift },
    keygroup = awful.key.keygroup.NUMROW,
    description = "move focused client to tag #n",
    group = "tag",
    on_press = function(index)
      if client.focus then
        local tag = client.focus.screen.tags[index]
        if tag then
          client.focus:move_to_tag(tag)
          tag:view_only()
        end
      end
    end,
  },

  -- Toggle tag on focused client.
  awful.key {
    modifiers = { modkey, ctrl, shift },
    keygroup = awful.key.keygroup.NUMROW,
    description = "toggle focused client on tag #n",
    group = "tag",
    on_press = function(index)
      if client.focus then
        local tag = client.focus.screen.tags[index]
        if tag then
          client.focus:toggle_tag(tag)
        end
      end
    end,
  },
}
-- }}}

-- {{{ focus
awful.keyboard.append_global_keybindings {
  awful.key({ modkey }, "Tab", function()
    awful.client.focus.history.previous()
    if client.focus then
      client.focus:raise()
    end
  end, { description = "go back", group = "client" }),

  -- focus by direction
  -- awful.key {
  --   modifiers = { modkey },
  --   keygroup = awful.key.keygroup.ARROWS,
  --   description = "focus by direction",
  --   group = "client",
  --   on_press = function(dir)
  --     awful.client.focus.bydirection(dir:lower())
  --   end,
  -- },
  awful.key({ modkey }, "h", function()
    awful.client.focus.bydirection("left")
  end, { description = "focus left", group = "client" }),
  awful.key({ modkey }, "j", function()
    awful.client.focus.bydirection("down")
  end, { description = "focus down", group = "client" }),
  awful.key({ modkey }, "k", function()
    awful.client.focus.bydirection("up")
  end, { description = "focus up", group = "client" }),
  awful.key({ modkey }, "l", function()
    awful.client.focus.bydirection("right")
  end, { description = "focus right", group = "client" }),

  -- focus by index
  awful.key({ modkey }, "Right", function()
    awful.client.focus.byidx(1)
  end, { description = "focus next", group = "client" }),
  awful.key({ modkey }, "Left", function()
    awful.client.focus.byidx(-1)
  end, { description = "focus previous", group = "client" }),

  -- focus urgent client
  awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),

  awful.key({ modkey, ctrl }, "n", function()
    local c = awful.client.restore()
    -- Focus restored client
    if c then
      c:emit_signal("request::activate", "key.unminimize", { raise = true })
    end
  end, { description = "restore minimized", group = "client" }),
}
-- }}}

-- {{{ screen
awful.keyboard.append_global_keybindings {
  -- focus screen
  awful.key({ modkey, ctrl }, "j", function()
    awful.screen.focus_relative(1)
  end, { description = "focus the next screen", group = "screen" }),
  awful.key({ modkey, ctrl }, "k", function()
    awful.screen.focus_relative(-1)
  end, { description = "focus the previous screen", group = "screen" }),
  -- screen arrangement
  awful.key({ modkey }, "s", function()
    require("xrandr").xrandr()
  end, { description = "screen arrangement", group = "screen" }),
}
-- }}}

-- {{{ layout
awful.keyboard.append_global_keybindings {
  -- swap clients
  awful.key({ modkey, shift }, "n", function()
    awful.client.swap.byidx(1)
  end, { description = "swap with next client by index", group = "client" }),
  awful.key({ modkey, shift }, "p", function()
    awful.client.swap.byidx(-1)
  end, { description = "swap with previous client by index", group = "client" }),

  awful.key({ modkey, shift }, "l", function()
    awful.tag.incmwfact(0.05)
  end, { description = "increase master width factor", group = "layout" }),
  awful.key({ modkey, shift }, "h", function()
    awful.tag.incmwfact(-0.05)
  end, { description = "decrease master width factor", group = "layout" }),

  -- awful.key({ modkey, shift }, "h", function()
  --   awful.tag.incnmaster(1, nil, true)
  -- end, { description = "increase the number of master clients", group = "layout" }),
  -- awful.key({ modkey, shift }, "l", function()
  --   awful.tag.incnmaster(-1, nil, true)
  -- end, { description = "decrease the number of master clients", group = "layout" }),
  -- awful.key({ modkey, ctrl }, "h", function()
  --   awful.tag.incncol(1, nil, true)
  -- end, { description = "increase the number of columns", group = "layout" }),
  -- awful.key({ modkey, ctrl }, "l", function()
  --   awful.tag.incncol(-1, nil, true)
  -- end, { description = "decrease the number of columns", group = "layout" }),
}

-- {{{ select layouts
awful.keyboard.append_global_keybindings {
  awful.key({ modkey }, "\\", function()
    awful.layout.inc(1)
  end, { description = "select next layout", group = "layout" }),
}
awful.keygrabber {
  start_callback = function()
    awesome.emit_signal("zl::layout_visible", true)
    -- layout_popup.visible = true
  end,
  stop_callback = function()
    awesome.emit_signal("zl::layout_visible", false)
    -- layout_popup.visible = false
  end,
  -- TODO: not work
  -- export_keybindings = true,
  stop_event = "release",
  stop_key = modkey, --{ "Escape", "Super_L", "Super_R", modkey },
  keybindings = {
    awful.key {
      modifiers = { modkey, shift },
      key = "space",
      on_press = function()
        awful.layout.inc(-1)
      end,
      description = "select previous layout",
      group = "layout",
    },
    awful.key {
      modifiers = { modkey },
      key = "space",
      on_press = function()
        awful.layout.inc(1)
      end,
      description = "select next layout",
      group = "layout",
    },
  },
}

-- awful.keyboard.append_global_keybindings {
--   awful.key({ modkey }, "space", function()
--     awful.layout.inc(1)
--   end, { description = "select next", group = "layout" }),
--   awful.key({ modkey, "Shift" }, "space", function()
--     awful.layout.inc(-1)
--   end, { description = "select previous", group = "layout" }),
-- }
-- }}}
-- }}}

awful.mouse.append_global_mousebindings {
  awful.button({}, 3, function()
    menu:toggle()
  end),
  awful.button({}, 4, awful.tag.viewprev),
  awful.button({}, 5, awful.tag.viewnext),
  awful.button({ "Control" }, 4, function()
    require("service.volume").set("1%+")
  end),
  awful.button({ "Control" }, 5, function()
    require("service.volume").set("1%-")
  end),
}
