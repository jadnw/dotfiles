local awful = require("awful")
local ruled = require("ruled")
local lib = require("lib")

--- Get screen geometry
local screen_width = awful.screen.focused().geometry.width
local screen_height = awful.screen.focused().geometry.height

ruled.client.connect_signal("request::rules", function()
  --- Global
  ruled.client.append_rule({
    id = "global",
    rule = {},
    properties = {
      raise = true,
      size_hints_honor = false,
      honor_workarea = true,
      honor_padding = true,
      maximized = false,
      maximized_horizontal = false,
      maximized_vertical = false,
      screen = awful.screen.focused,
      focus = awful.client.focus.filter,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
    },
  })

  --- Tasklist order
  ruled.client.append_rule({
    id = "tasklist_order",
    rule = {},
    properties = {},
    callback = awful.client.setslave,
  })

  --- Titlebar rules
  ruled.client.append_rule({
    id = "titlebars",
    rule_any = {
      class = {
        "Spotify",
        "Org.gnome.Nautilus",
        "Peek",
      },
    },
    properties = {
      titlebars_enabled = false,
    },
  })

  --- Float
  ruled.client.append_rule({
    id = "floating",
    rule_any = {
      instance = {
        "Devtools", --- Firefox devtools
        "btop",
        "nmtui",
      },
      class = {
        "Lxappearance",
        "Nm-connection-editor",
        "Pavucontrol",
        "nmtui",
      },
      name = {
        "Event Tester", -- xev
      },
      role = {
        "AlarmWindow",
        "pop-up",
        "GtkFileChooserDialog",
        "conversation",
      },
      type = {
        "dialog",
      },
    },
    properties = {
      floating = true,
      ontop = true,
      width = screen_width * 0.60,
      height = screen_height * 0.60,
      placement = lib.client.centered_client_placement,
    },
  })

  --- Float small clients
  ruled.client.append_rule({
    id = "floating-small",
    rule_any = {
      instance = {
        "float-term",
        "calc",
      },
      class = {
        "float-term",
        "calc",
      },
      name = {},
      role = {},
      type = {},
    },
    properties = {
      floating = true,
      ontop = true,
      width = screen_width * 0.40,
      height = screen_height * 0.40,
      placement = lib.client.centered_client_placement,
    },
  })

  --- Centered
  ruled.client.append_rule({
    id = "centered",
    rule_any = {
      type = {
        "dialog",
      },
      class = {
        --- "discord",
      },
      role = {
        "GtkFileChooserDialog",
        "conversation",
      },
    },
    properties = { placement = lib.client.centered_client_placement },
  })

  --- Music clients (usually a terminal running ncmpcpp)
  ruled.client.append_rule({
    rule_any = {
      class = {
        "music",
      },
      instance = {
        "music",
      },
    },
    properties = {
      floating = true,
      width = screen_width * 0.40,
      height = screen_height * 0.40,
      placement = lib.client.centered_client_placement,
    },
  })

  --- Image viewers
  ruled.client.append_rule({
    rule_any = {
      class = {
        "feh",
        "imv",
      },
    },
    properties = {
      floating = true,
      width = screen_width * 0.8,
      height = screen_height * 0.8,
    },
    callback = function(c)
      awful.placement.centered(c, { honor_padding = true, honor_workarea = true })
    end,
  })
end)
