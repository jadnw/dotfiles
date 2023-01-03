local awful = require("awful")
local wibox = require("wibox")

local factory = require("factory")
local dpi = require("lib.utils").dpi

return function()
  local profile = require("ui.dashboard.profile")()
  local sysguard = require("ui.dashboard.sysguard")()
  local quicksettings = require("ui.dashboard.quicksettings")()
  local programming_joke = require("ui.dashboard.programming_joke")()
  local music_player = require("ui.dashboard.music_player")()

  local dashboard = factory.create_popup({
    child = {
      {
        {
          profile,
          sysguard,
          spacing = dpi(16),
          widget = wibox.layout.fixed.vertical,
        },
        nil,
        {
          programming_joke,
          music_player,
          spacing = dpi(16),
          widget = wibox.layout.fixed.vertical,
        },
        spacing = dpi(16),
        widget = wibox.layout.flex.horizontal,
      },
      quicksettings,
      spacing = dpi(16),
      widget = wibox.layout.fixed.vertical,
    },
    placement = awful.placement.centered,
  })

  awesome.connect_signal("dashboard::toggle", dashboard.toggle_visible) -- luacheck: no global

  return dashboard
end
