local awful = require("awful")
local beautiful = require("beautiful")

local apps = require("configurations.apps")
local factory = require("factory")

return function()
  local screencast = factory.create_qs_button({
    icon = beautiful.icon_recorder,
    on_click = function()
      awful.spawn(apps.utils.screencast)
    end,
    on_right_click = function() end,
  })
  screencast.set_tooltip("Screen Recoder")

  return screencast
end
