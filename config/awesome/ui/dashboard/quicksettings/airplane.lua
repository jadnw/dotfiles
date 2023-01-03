local awful = require("awful")
local beautiful = require("beautiful")

local factory = require("factory")

return function()
  local airplane_state = false

  local airplane = factory.create_qs_button({
    icon = beautiful.icon_airplane_off,
    on_click = function()
      awesome.emit_signal("airplane::toggle")
    end,
  })
  airplane.set_tooltip("Airplane Mode: Off")

  local airplane_toggle = function()
    airplane_state = not airplane_state

    if airplane_state then
      awful.spawn("bluetoothctl power off")
      awful.spawn("nmcli n off")

      airplane.set_icon(beautiful.icon_airplane)
      airplane:set_bg(beautiful.palette.accent)
      airplane.set_tooltip("Airplane Mode: On")
    else
      awful.spawn("bluetoothctl power on")
      awful.spawn("nmcli n on")

      airplane.set_icon(beautiful.icon_airplane_off)
      airplane:set_bg(beautiful.palette.black)
      airplane.set_tooltip("Airplane Mode: Off")
    end
  end

  awesome.connect_signal("airplane::toggle", airplane_toggle)

  return airplane
end
