local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local factory = require("factory")
local dpi = require("lib.utils").dpi

local indicator = require("modules.screencast.indicator")

local screencast_box = factory.create_popup({
  child = {
    nil,
    indicator,
    nil,
    layout = wibox.layout.align.vertical,
  },
  padding = dpi(6),
  placement = function(w)
    awful.placement.bottom_right(w, {
      margins = {
        right = beautiful.useless_gap,
        bottom = beautiful.wibar_height + beautiful.useless_gap,
      },
    })
  end,
})

-- Do not allow right click to close popup
screencast_box.buttons = {}

return function()
  screencast_box:toggle_visible()
end
