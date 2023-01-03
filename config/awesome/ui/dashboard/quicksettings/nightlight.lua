local awful = require("awful")
local beautiful = require("beautiful")

local apps = require("configurations.apps")
local factory = require("factory")
local lib = require("lib")

return function()
  local nightlight = factory.create_qs_button({
    icon = beautiful.icon_nightlight_disabled,
    on_click = function()
      awesome.emit_signal("nightlight::toggle")
    end,
    on_right_click = function() end,
  })

  awful.widget.watch([[pgrep wlsunset]], _G.configs.nightlight.sampling_time, function(_, stdout)
    stdout = lib.utils.trim(stdout)

    if stdout then
      nightlight.set_icon(beautiful.icon_nightlight_disabled)
      nightlight:set_bg(beautiful.palette.black)
      nightlight.set_tooltip("Nightlight: Disabled")
    else
      nightlight.set_icon(beautiful.icon_nightlight)
      nightlight:set_bg(beautiful.palette.accent)
      nightlight.set_tooltip("Nightlight: Enabled")
    end
  end)

  local nightlight_toggle = function()
    awful.spawn.easy_async_with_shell(apps.utils.nightlight, function(stdout)
      stdout = lib.utils.trim(stdout)

      if stdout == "false" then
        nightlight.set_icon(beautiful.icon_nightlight_disabled)
        nightlight:set_bg(beautiful.palette.black)
        nightlight.set_tooltip("Nightlight: Disabled")
      else
        nightlight.set_icon(beautiful.icon_nightlight)
        nightlight:set_bg(beautiful.palette.accent)
        nightlight.set_tooltip("Nightlight: Enabled")
      end
    end)
  end

  awesome.connect_signal("nightlight::toggle", nightlight_toggle)

  return nightlight
end
