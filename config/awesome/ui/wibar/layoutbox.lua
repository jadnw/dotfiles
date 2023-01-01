local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local factory = require("factory")
local dpi = require("lib.utils").dpi

return function(s)
  local layoutbox_buttons = gears.table.join(
    awful.button({}, 1, function()
      awful.layout.inc(1)
    end), -- Left click
    awful.button({}, 3, function()
      awful.layout.inc(-1)
    end), -- Right click
    awful.button({}, 4, function()
      awful.layout.inc(1)
    end), -- Scroll up
    awful.button({}, 5, function()
      awful.layout.inc(-1)
    end) -- Scroll down
  )
  s.layoutbox = awful.widget.layoutbox(s)
  s.layoutbox:buttons(layoutbox_buttons)

  local widget = factory.create_button({
    child = {
      s.layoutbox,
      widget = wibox.container.margin,
    },
    bg = beautiful.palette.bg3,
  })

  return widget
end
