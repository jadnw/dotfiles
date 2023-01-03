local awful = require("awful")
local beautiful = require("beautiful")

local apps = require("configurations.apps")
local factory = require("factory")
local lib = require("lib")

return function()
  local bluetooth = factory.create_qs_button({
    icon = beautiful.icon_bluetooth_off,
    on_click = function()
      awesome.emit_signal("bluetooth::toggle")
    end,
    on_right_click = function() end,
  })

  awful.widget.watch(apps.utils.bluetooth .. " get_power_state", _G.configs.bluetooth.sampling_time, function(_, stdout)
    stdout = lib.utils.trim(stdout)

    if stdout == "yes" then
      bluetooth.set_icon(beautiful.icon_bluetooth)
      bluetooth:set_bg(beautiful.palette.accent)
      bluetooth.set_tooltip("Bluetooth: On")
    else
      bluetooth.set_icon(beautiful.icon_bluetooth_off)
      bluetooth:set_bg(beautiful.palette.black)
      bluetooth.set_tooltip("Bluetooth: Off")
    end
  end)

  local bluetooth_toggle = function()
    awful.spawn.easy_async_with_shell(apps.utils.bluetooth .. " toggle", function(stdout)
      stdout = lib.utils.trim(stdout)

      if stdout == "on" then
        bluetooth.set_icon(beautiful.icon_bluetooth)
        bluetooth:set_bg(beautiful.palette.accent)
        bluetooth.set_tooltip("Bluetooth: On")
      else
        bluetooth.set_icon(beautiful.icon_bluetooth_off)
        bluetooth:set_bg(beautiful.palette.black)
        bluetooth.set_tooltip("Bluetooth: Off")
      end
    end)
  end

  awesome.connect_signal("bluetooth::toggle", bluetooth_toggle)

  return bluetooth
end
