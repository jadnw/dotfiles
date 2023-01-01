local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local apps = require("configurations.apps")
local factory = require("factory")
local dpi = require("lib.utils").dpi

local label = wibox.widget({
  text = "Recording ....",
  font = beautiful.font,
  widget = wibox.widget.textbox,
})

local dot = wibox.widget({
  {
    shape = gears.shape.circle,
    bg = beautiful.palette.red,
    forced_width = dpi(20),
    forced_height = dpi(20),
    widget = wibox.widget.background,
  },
  {
    label,
    fg = beautiful.palette.fg0,
    widget = wibox.widget.background,
  },
  spacing = dpi(16),
  layout = wibox.layout.fixed.horizontal,
})

local indicator = factory.create_button({
  child = dot,
  on_click = function()
    awful.spawn(apps.utils.screencast, false)
  end,
})

indicator.set_label = function(lbl)
  label:set_text(lbl)
end

indicator:connect_signal("mouse::enter", function()
  indicator.set_label("Stop recording")
end)

indicator:connect_signal("mouse::leave", function()
  indicator.set_label("Recording ....")
end)

return indicator
