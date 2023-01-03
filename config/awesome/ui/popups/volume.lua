local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local factory = require("factory")
local dpi = require("lib.utils").dpi

return function(s)
  local set_volume = function(value)
    awful.spawn("pamixer --set-volume " .. value, false)
    awesome.emit_signal("volume::change", value)
  end

  local volume_slider = factory.create_slider({
    id = "volume_slider",
    icon = "",
    active_color = beautiful.palette.magenta,
    on_change = set_volume,
  })

  local device = wibox.widget({
    text = "Finding audio device...",
    font = beautiful.font,
    widget = wibox.widget.textbox,
  })

  local volume_popup = factory.create_popup({
    screen = s,
    child = {
      {
        {
          text = "Device: ",
          font = beautiful.font,
          widget = wibox.widget.textbox,
        },
        {
          device,
          step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
          fps = 60,
          speed = 75,
          widget = wibox.container.scroll.horizontal,
        },
        nil,
        layout = wibox.layout.align.horizontal,
      },
      nil,
      volume_slider,
      layout = wibox.layout.align.vertical,
    },
    placement = function(w)
      awful.placement.bottom_right(w, {
        margins = {
          right = beautiful.useless_gap + dpi(2),
          bottom = beautiful.wibar_height + beautiful.useless_gap + dpi(2),
        },
      })
    end,
    width = dpi(400),
    height = dpi(90),
  })

  -- Set volume_slider value through the method of volume_popup
  volume_popup.set_volume_value = function(value)
    volume_slider.set_value(value)
  end
  -- Set device
  volume_popup.set_device = function(name)
    device:set_text(name)
  end

  awesome.connect_signal("volume_popup::toggle", function() -- luacheck: no global
    volume_popup.toggle_visible()
  end)
  awesome.connect_signal("volume_popup::device", function(name) -- luacheck: no global
    volume_popup.set_device(name)
  end)
  awesome.connect_signal("volume_popup::value", function(val) -- luacheck: no global
    volume_popup.set_volume_value(val)
  end)

  return volume_popup
end
