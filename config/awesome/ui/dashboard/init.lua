local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local factory = require("factory")
local lib = require("lib")
local dpi = require("lib.utils").dpi

return function()
  local profile = require("ui.dashboard.profile")()
  local sysguard = require("ui.dashboard.sysguard")()
  local quicksettings = require("ui.dashboard.quicksettings")()

  local dashboard = factory.create_popup({
    child = {
      {
        profile,
        sysguard,
        quicksettings,
        spacing = dpi(16),
        widget = wibox.layout.fixed.vertical,
      },
      widget = wibox.layout.fixed.horizontal,
    },
    placement = awful.placement.centered,
  })

  awesome.connect_signal("dashboard::toggle", dashboard.toggle_visible) -- luacheck: no global

  return dashboard
end
