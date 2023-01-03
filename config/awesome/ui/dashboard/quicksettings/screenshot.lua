local awful = require("awful")
local beautiful = require("beautiful")

local apps = require("configurations.apps")
local factory = require("factory")

return function()
  local screenshot = factory.create_qs_button({
    icon = beautiful.icon_screenshot,
    on_click = function()
      awesome.emit_signal("dashboard::toggle")
      awful.spawn(apps.utils.screenshot_screen)
    end,
  })
  screenshot.set_tooltip("Screenshot")

  return screenshot
end
