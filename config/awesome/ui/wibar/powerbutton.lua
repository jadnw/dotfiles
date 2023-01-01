local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local dpi = require("lib.utils").dpi
local apps = require("configurations.apps")
local factory = require("factory")

return function()
  local power_icon = wibox.widget({
    {
      id = "icon",
      text = beautiful.icon_power,
      font = beautiful.icon_font .. " Round 16",
      widget = wibox.widget.textbox,
    },
    left = dpi(6),
    right = dpi(4),
    widget = wibox.container.margin,
  })

  local powerbutton = factory.create_button({
    child = power_icon,
    tooltip = true,
    padding_right = dpi(10),
    bg = beautiful.palette.red,
    on_click = function()
      awful.spawn(apps.utils.powermenu)
    end,
  })

  powerbutton.set_tooltip("Time to take some rest")

  return powerbutton
end
