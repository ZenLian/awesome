local awful = require("awful")
local C = require("config")

local modkey = C.keys.modkey or "Mod4"
local ctrl = "Control"
local shift = "Shift"

local clientkeys = {
  awful.key({ modkey }, "f", function(c)
    c.fullscreen = not c.fullscreen
    c:raise()
  end, { description = "toggle fullscreen", group = "client" }),

  awful.key({ modkey }, "q", function(c)
    c:kill()
  end, { description = "quit", group = "client" }),

  awful.key({ modkey, shift }, "f", function(c)
    awful.client.floating.toggle()
  end, { description = "toggle floating", group = "client" }),

  awful.key({ modkey, ctrl }, "Return", function(c)
    c:swap(awful.client.getmaster())
  end, { description = "move to master", group = "client" }),

  awful.key({ modkey }, "o", function(c)
    c:move_to_screen()
  end, { description = "move to screen", group = "client" }),

  awful.key({ modkey }, "t", function(c)
    c.ontop = not c.ontop
  end, { description = "toggle ontop", group = "client" }),

  awful.key({ modkey, shift }, "t", function(c)
    awful.titlebar.toggle(c)
  end, { description = "toggle titlebar", group = "client" }),

  awful.key({ modkey, ctrl }, "t", function()
    require("screen.titlebar").toggle()
  end, { description = "toggle all titlebar", group = "client" }),

  awful.key({ modkey }, "z", function(c)
    c.minimized = true
  end, { description = "minimize", group = "client" }),

  awful.key({ modkey }, "m", function(c)
    c.maximized = not c.maximized
    c:raise()
  end, { description = "(un)maximize", group = "client" }),

  awful.key({ modkey, ctrl }, "m", function(c)
    c.maximized_vertical = not c.maximized_vertical
    c:raise()
  end, { description = "(un)maximize vertically", group = "client" }),
  awful.key({ modkey, shift }, "m", function(c)
    c.maximized_horizontal = not c.maximized_horizontal
    c:raise()
  end, { description = "(un)maximize horizontally", group = "client" }),
}

local clientbuttons = {
  awful.button({}, 1, function(c)
    c:activate { context = "mouse_click" }
  end),

  awful.button({ modkey }, 1, function(c)
    c:activate { context = "mouse_click", action = "mouse_move" }
  end),

  awful.button({ modkey }, 3, function(c)
    c:activate { context = "mouse_click", action = "mouse_resize" }
  end),
}

client.connect_signal("request::default_keybindings", function()
  awful.keyboard.append_client_keybindings(clientkeys)
end)
client.connect_signal("request::default_mousebindings", function()
  awful.mouse.append_client_mousebindings(clientbuttons)
end)
