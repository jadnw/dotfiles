local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local hotkeys_popup = require("awful.hotkeys_popup")
local naughty = require("naughty")

local apps = require("configurations.apps")
local lib = require("lib")

--- Key Modifier Aliases
--------------------------------------------------------------------------------
local mod = "Mod4"
local alt = "Mod1"
local ctrl = "Control"
local shift = "Shift"

--- Awesome
--------------------------------------------------------------------------------
awful.keyboard.append_global_keybindings({
  -- Restart Awesome
  awful.key({ mod, ctrl }, "r", awesome.restart, { description = "restart awesome", group = "Awesome" }),
  -- Quit Awesome
  awful.key({ mod, ctrl }, "q", awesome.quit, { description = "quit awesome", group = "Awesome" }),
  -- Show help
  awful.key({ mod }, "F1", hotkeys_popup.show_help, { description = "show help", group = "Awesome" }),
})

--- Application Shortcuts
--------------------------------------------------------------------------------
awful.keyboard.append_global_keybindings({
  -- Terminal
  awful.key({ mod }, "Return", function()
    awful.spawn(apps.default.terminal)
  end, { description = "open terminal", group = "Apps" }),
  -- Floating Terminal
  awful.key({ mod, shift }, "Return", function()
    awful.spawn(apps.default.float_term)
  end, { description = "open float terminal", group = "Apps" }),
  -- Calculator
  awful.key({ mod }, "c", function()
    awful.spawn(apps.default.calculator)
  end, { description = "open float calculator", group = "Apps" }),
  -- File Manager
  awful.key({ mod }, "e", function()
    awful.spawn.with_shell(apps.default.file_manager)
  end, { description = "open file manager", group = "Apps" }),
  -- Web Browser
  awful.key({ mod }, "b", function()
    awful.spawn(apps.default.browser)
  end, { description = "open browser", group = "Apps" }),
  -- Dev Browser
  awful.key({ mod }, "w", function()
    awful.spawn(apps.default.dev_browser)
  end, { description = "open dev browser", group = "Apps" }),
  -- Applications Launcher
  awful.key({ mod }, "d", function()
    awful.spawn(apps.default.launcher)
  end, { description = "open applications launcher", group = "Apps" }),
})

--- Utilities
--------------------------------------------------------------------------------
awful.keyboard.append_global_keybindings({
  -- Dashboard
  awful.key({ mod, shift }, "d", function()
    awesome.emit_signal("dashboard::toggle") -- luacheck: no global
  end, { description = "launch dashboard", group = "Utilities" }),
  -- Power Menu
  awful.key({ mod, shift }, "q", function()
    awful.spawn(apps.utils.powermenu, false)
  end, { description = "open power menu", group = "Utilities" }),
  -- Color Picker
  awful.key({ mod, alt }, "c", function()
    awful.spawn(apps.utils.colorpicker, false)
  end, { description = "open color picker", group = "Utilities" }),
  -- Recent Documents
  awful.key({ mod }, "z", function()
    awful.spawn(apps.utils.documents, false)
  end, { description = "open recent documents", group = "Utilities" }),
  -- Windows List
  awful.key({ mod }, "slash", function()
    awful.spawn(apps.utils.windows_list, false)
  end, { description = "open windows list", group = "Utilities" }),
  -- Nightlight
  awful.key({ mod, shift }, "n", function()
    awful.spawn(apps.utils.nightlight, false)
  end, { description = "toggle nightlight mode", group = "Utilities" }),
  -- Screenshot
  awful.key({ mod }, "p", function()
    awful.spawn(apps.utils.screenshot, false)
  end, { description = "open screenshot menu", group = "Utilities" }),
  -- Screenshot Screen
  awful.key({ mod, shift }, "p", function()
    awful.spawn(apps.utils.screenshot_screen, false)
  end, { description = "take a screen screenshot", group = "Utilities" }),
  -- Screenshot Window
  awful.key({ mod, ctrl }, "p", function()
    awful.spawn(apps.utils.screenshot_window, false)
  end, { description = "take a window screenshot", group = "Utilities" }),
  -- Screenshot Crop
  awful.key({ mod, alt }, "p", function()
    awful.spawn(apps.utils.screenshot_crop, false)
  end, { description = "take a crop screenshot", group = "Utilities" }),
  -- Screencast
  awful.key({ mod }, "r", function()
    awful.spawn(apps.utils.screencast, false)
  end, { description = "open screen recorder", group = "Utilities" }),
  -- Lockscreen
  awful.key({ mod, shift }, "l", function()
    require("modules.lockscreen.lockscreen")()
  end, { description = "lock screen", group = "Utilities" }),
  -- Dismiss all notifications
  awful.key({ mod }, "Escape", function()
    naughty.destroy_all_notifications(nil, naughty.notification_closed_reason.dismissed_by_user)
  end, { description = "Dismiss all notifications", group = "Utilities" }),
})

--- Tags
--------------------------------------------------------------------------------
awful.keyboard.append_global_keybindings({
  awful.key({ mod }, "Left", awful.tag.viewprev, { description = "View previous", group = "Tags" }),
  awful.key({ mod }, "Right", awful.tag.viewnext, { description = "View next", group = "Tags" }),
  awful.key({ mod }, "Escape", awful.tag.history.restore, { description = "Go back", group = "Tags" }),
  awful.key({
    modifiers = { mod },
    keygroup = "numrow",
    description = "only view tag",
    group = "tag",
    on_press = function(index)
      local screen = awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
        tag:view_only()
      end
    end,
  }),
  awful.key({
    modifiers = { mod, ctrl },
    keygroup = "numrow",
    description = "toggle tag",
    group = "tag",
    on_press = function(index)
      local screen = awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
        awful.tag.viewtoggle(tag)
      end
    end,
  }),
  awful.key({
    modifiers = { mod, shift },
    keygroup = "numrow",
    description = "move focused client to tag",
    group = "tag",
    on_press = function(index)
      if client.focus then
        local tag = client.focus.screen.tags[index]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end,
  }),
  awful.key({
    modifiers = { mod, ctrl, shift },
    keygroup = "numrow",
    description = "toggle focused client on tag",
    group = "tag",
    on_press = function(index)
      if client.focus then
        local tag = client.focus.screen.tags[index]
        if tag then
          client.focus:toggle_tag(tag)
        end
      end
    end,
  }),
})

--- Focus & Resize
--------------------------------------------------------------------------------
awful.keyboard.append_global_keybindings({
  -- Focus
  awful.key({ mod }, "j", function()
    awful.client.focus.byidx(1)
  end, { description = "Focus next client", group = "Clients" }),
  awful.key({ mod }, "k", function()
    awful.client.focus.byidx(-1)
  end, { description = "Focus prev client", group = "Clients" }),
  awful.key({ mod }, "Tab", function()
    awful.client.focus.history.previous()
    if client.focus then
      client.focus:raise()
    end
  end, { description = "Focus back", group = "Clients" }),

  -- Resize
  awful.key({ mod, ctrl }, "j", function()
    lib.client.resize_client(client.focus, "down")
  end, { description = "Resize down", group = "Clients" }),
  awful.key({ mod, ctrl }, "k", function()
    lib.client.resize_client(client.focus, "up")
  end, { description = "Resize up", group = "Clients" }),
  awful.key({ mod, ctrl }, "h", function()
    lib.client.resize_client(client.focus, "left")
  end, { description = "Resize left", group = "Clients" }),
  awful.key({ mod, ctrl }, "l", function()
    lib.client.resize_client(client.focus, "right")
  end, { description = "Resize right", group = "Clients" }),
})

--- Clients Movements
--------------------------------------------------------------------------------
client.connect_signal("request::default_mousebindings", function()
  awful.mouse.append_client_mousebindings({
    awful.button({}, 1, function(c)
      c:activate({ context = "mouse_click" })
    end),
    awful.button({ mod }, 1, function(c)
      c:activate({ context = "mouse_click", action = "mouse_move" })
    end),
    awful.button({ mod }, 3, function(c)
      c:activate({ context = "mouse_click", action = "mouse_resize" })
    end),
  })
end)

client.connect_signal("request::default_keybindings", function()
  awful.keyboard.append_client_keybindings({
    -- Swap
    awful.key({ mod, shift }, "j", function()
      awful.client.swap.byidx(1)
    end, { description = "Swap with next client", group = "Clients" }),
    awful.key({ mod, shift }, "k", function()
      awful.client.swap.byidx(-1)
    end, { description = "Swap with prev client", group = "Clients" }),

    -- Move client relatively
    awful.key({ mod, shift }, "Down", function(c)
      c:relative_move(0, dpi(10), 0, 0)
    end, { description = "Move client down by 10px", group = "Clients" }),
    awful.key({ mod, shift }, "Up", function(c)
      c:relative_move(0, dpi(-10), 0, 0)
    end, { description = "Move client up by 10px", group = "Clients" }),
    awful.key({ mod, shift }, "Left", function(c)
      c:relative_move(dpi(-10), 0, 0, 0)
    end, { description = "Move client left by 10px", group = "Clients" }),
    awful.key({ mod, shift }, "Right", function(c)
      c:relative_move(dpi(10), 0, 0, 0)
    end, { description = "Move client right by 10px", group = "Clients" }),

    -- Toggle floating
    awful.key(
      { mod, ctrl },
      "space",
      awful.client.floating.toggle,
      { description = "Toggle floating", group = "Clients" }
    ),

    -- Toggle fullscreen
    awful.key({ mod }, "f", function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end, { description = "Toggle fullscreen", group = "Clients" }),

    --- Minimize windows
    awful.key({ mod }, "n", function(c)
      -- The client currently has the input focus, so it cannot be
      -- minimized, since minimized clients can't have the focus.
      c.minimized = true
    end, { description = "Minimize", group = "Clients" }),

    --- Un-minimize windows
    awful.key({ mod, ctrl }, "n", function()
      local c = awful.client.restore()
      -- Focus restored client
      if c then
        c:activate({ raise = true, context = "key.unminimize" })
      end
    end, { description = "Restore minimized", group = "Clients" }),

    --- Keep on top
    awful.key({ mod }, "p", function(c)
      c.ontop = not c.ontop
    end, { description = "Keep on top", group = "Clients" }),

    --- Sticky
    awful.key({ mod, shift }, "p", function(c)
      c.sticky = not c.sticky
    end, { description = "Sticky", group = "Clients" }),

    --- Close window
    awful.key({ mod, shift }, "c", function(c)
      c:kill()
    end, { description = "Close", group = "Clients" }),

    --- Center window
    awful.key({ mod }, "c", function(c)
      awful.placement.centered(c, { honor_workarea = true, honor_padding = true })
    end, { description = "Center", group = "Clients" }),

    --- Window switcher
    awful.key({ alt }, "Tab", function()
      awesome.emit_signal("window_switcher::turn_on")
    end, { description = "Switch", group = "Clients" }),
  })
end)

--- Layouts
--------------------------------------------------------------------------------
awful.keyboard.append_global_keybindings({
  -- Set tiling layout
  awful.key({ mod }, "s", function()
    awful.layout.set(awful.layout.suit.tile)
  end, { description = "set tile layout", group = "Layouts" }),
  -- Set floating layout
  awful.key({ mod, shift }, "s", function()
    awful.layout.set(awful.layout.suit.floating)
  end, { description = "set floating layout", group = "Layouts" }),
  --- Number of columns
  awful.key({ mod, alt }, "k", function()
    awful.tag.incncol(1, nil, true)
  end, { description = "increase the number of columns", group = "Layouts" }),
  awful.key({ mod, alt }, "j", function()
    awful.tag.incncol(-1, nil, true)
  end, { description = "decrease the number of columns", group = "Layouts" }),
  awful.key({ mod, alt }, "Up", function()
    awful.tag.incncol(1, nil, true)
  end, { description = "increase the number of columns", group = "Layouts" }),
  awful.key({ mod, alt }, "Down", function()
    awful.tag.incncol(-1, nil, true)
  end, { description = "decrease the number of columns", group = "Layouts" }),
})
