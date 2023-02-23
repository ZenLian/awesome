local awful = require("awful")
local ruled = require("ruled")

ruled.client.connect_signal("request::rules", function()
  -- Global
  ruled.client.append_rule {
    id = "global",
    rule = {},
    properties = {
      focus = awful.client.focus.filter,
      raise = true,
      size_hints_honor = false,
      screen = awful.screen.preferred,
      -- titlebars_enabled = true,
      placement = awful.placement.centered + awful.placement.no_overlap + awful.placement.no_offscreen,
      -- shape = utils.shape.rrect(8),
    },
  }

  -- Floating clients.
  ruled.client.append_rule {
    id = "floating",
    rule_any = {
      instance = {
        "Floaterm",
      },
      class = {
        "Lxappearance",
        "Galculator",
        "Xarchiver",
        "Zathura",
        "fcitx5-config-qt",
      },
      -- Note that the name property shown in xprop might be set slightly after creation of the client
      -- and the name shown there might not match defined rules here.
      name = {
        "Event Tester", -- xev.
      },
      role = {
        "AlarmWindow", -- Thunderbird's calendar.
        "ConfigManager", -- Thunderbird's about:config.
        "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
      },
    },
    properties = { floating = true, placement = awful.placement.centered },
  }

  -- Add titlebars
  -- ruled.client.append_rule {
  --   id = "titlebars",
  --   rule_any = { type = { "dialog" } },
  --   properties = { titlebars_enabled = true },
  -- }

  -- Set Firefox to always map on the tag named "2" on screen 1.
  -- ruled.client.append_rule {
  --     rule       = { class = "Firefox"     },
  --     properties = { screen = 1, tag = "2" }
  -- }

  -- NOTE: below not defaults
  -- Borders
  -- ruled.client.append_rule {
  --   id = "borders",
  --   rule_any = { type = { "normal", "dialog" } },
  --   except_any = {
  --     role = { "Popup" },
  --     type = { "splash" },
  --     name = { "^discord.com is sharing your screen.$" },
  --   },
  --   properties = {
  --     border_width = beautiful.border_width,
  --     border_color = beautiful.border_normal,
  --   },
  -- }

  -- Center Placement
  -- ruled.client.append_rule {
  --   id = "center_placement",
  --   rule_any = {
  --     type = { "dialog" },
  --     class = { "Steam", "discord", "markdown_input", "nemo", "thunar" },
  --     instance = { "markdown_input" },
  --     role = { "GtkFileChooserDialog" },
  --   },
  --   properties = { placement = awful.placement.center },
  -- }

  -- Terminal: Float/Center/Always On Top
  ruled.client.append_rule {
    id = "terminal",
    rule_any = {
      class = { "Floaterm" },
    },
    properties = {
      floating = true,
      placement = awful.placement.centered,
      ontop = true,
      -- width = 800,
      -- height = 600,
      -- x = 2000,
      -- y = 1120,
    },
  }
end)
