local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local dpi = require("lib.utils").dpi
local apps = require("configurations.apps")
local factory = require("factory")

return function()
  require("ui.dashboard")()

  local launcher_icon = wibox.widget({
    {
      id = "icon",
      text = beautiful.icon_dashboard,
      font = beautiful.icon_font .. " Round 16",
      widget = wibox.widget.textbox,
    },
    left = dpi(6),
    right = dpi(4),
    widget = wibox.container.margin,
  })

  local launcher = factory.create_button({
    child = launcher_icon,
    tooltip = true,
    padding_right = dpi(10),
    bg = beautiful.palette.accent,
    on_click = function()
      awesome.emit_signal("dashboard::toggle")
    end,
  })

  launcher.set_tooltip("Launch to space")

  return launcher
end
