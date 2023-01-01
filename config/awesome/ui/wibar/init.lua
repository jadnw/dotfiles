local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local dpi = require("lib.utils").dpi

--- MODULES
----------------------------------------------------------------------------------------------------
local create_bar = function(s)
  -- Wibar
  s.wibar = awful.wibar({
    position = "bottom",
    screen = s,
    type = "dock",
    width = s.geometry.width,
    height = beautiful.wibar_height,
    border_width = beautiful.wibar_border_width,
    border_color = beautiful.wibar_border_color,
    shape = gears.shape.rectangle,
    bg = beautiful.wibar_bg,
    fg = beautiful.wibar_fg,
  })

  -- Create modules
  -- local system_monitor = require("ui.wibar.system-monitor")()

  local launcher = require("ui.wibar.launcher")()
  local clock = require("ui.wibar.clock")(s)
  local taglist = require("ui.wibar.taglist")(s)
  local layoutbox = require("ui.wibar.layoutbox")(s)
  local volume = require("ui.wibar.volume")(s)
  local powerbutton = require("ui.wibar.powerbutton")()
  local network = require("ui.wibar.network")(s)
  local notifications = require("ui.wibar.notifications")()
  local sysguard = require("ui.wibar.sysguard")()
  local systray = require("ui.wibar.systray")()

  -- Containers
  local left_modules = wibox.widget({
    launcher,
    taglist,
    spacing = dpi(0),
    layout = wibox.layout.fixed.horizontal,
  })
  local right_modules = wibox.widget({
    systray,
    sysguard,
    volume,
    notifications,
    network,
    clock,
    layoutbox,
    powerbutton,
    spacing = dpi(4),
    layout = wibox.layout.fixed.horizontal,
  })

  -- Wibar Setup
  s.wibar:setup({
    {
      {
        left_modules,
        nil,
        right_modules,
        expand = "none",
        layout = wibox.layout.align.horizontal,
      },
      top = dpi(4),
      bottom = dpi(4),
      left = dpi(8),
      right = dpi(8),
      widget = wibox.container.margin,
    },
    fill_horizontal = true,
    widget = wibox.container.background,
  })
end

awful.screen.connect_for_each_screen(function(s)
  create_bar(s)
end)
