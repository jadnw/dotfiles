local beautiful = require("beautiful")
local wibox = require("wibox")

local lib = require("lib")
local dpi = lib.utils.dpi

return function()
  local airplane = require("ui.dashboard.quicksettings.airplane")()
  local network = require("ui.dashboard.quicksettings.network")()
  local bluetooth = require("ui.dashboard.quicksettings.bluetooth")()
  local nightlight = require("ui.dashboard.quicksettings.nightlight")()
  local sound = require("ui.dashboard.quicksettings.sound")()
  local microphone = require("ui.dashboard.quicksettings.microphone")()
  local screenshot = require("ui.dashboard.quicksettings.screenshot")()
  local screencast = require("ui.dashboard.quicksettings.screencast")()

  -- Quick Settings
  local quicksettings = wibox.widget({
    {
      {
        airplane,
        network,
        bluetooth,
        nightlight,
        sound,
        microphone,
        screenshot,
        screencast,
        spacing = dpi(56),
        widget = wibox.layout.fixed.horizontal,
      },
      margins = dpi(24),
      widget = wibox.container.margin,
    },
    border_width = dpi(1),
    border_color = beautiful.palette.bg4,
    shape = lib.ui.rrect(4),
    widget = wibox.container.background,
  })

  return quicksettings
end
