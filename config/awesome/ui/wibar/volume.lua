local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local lib = require("lib")
local dpi = require("lib.utils").dpi
local factory = require("factory")
local apps = require("configurations.apps")

return function(s)
  require("ui.popups.volume")(s)

  local volume_label = wibox.widget({
    {
      id = "icon",
      text = beautiful.icon_volume,
      font = beautiful.icon_font .. " Round 16",
      widget = wibox.widget.textbox,
    },
    {
      id = "text",
      text = "100%",
      font = beautiful.font .. " Semibold 11",
      widget = wibox.widget.textbox,
    },
    spacing = dpi(6),
    layout = wibox.layout.fixed.horizontal,
  })

  local icon = volume_label:get_children_by_id("icon")[1]
  local text = volume_label:get_children_by_id("text")[1]

  local volume = factory.create_button({
    child = volume_label,
    tooltip = true,
    padding_right = dpi(10),
    bg = beautiful.palette.magenta,
    on_click = function()
      awesome.emit_signal("volume_popup::toggle") -- luacheck: no global
    end,
    on_right_click = function()
      awesome.spawn(apps.default.volume_control) -- luacheck: no global
    end,
  })

  awesome.connect_signal("volume::change", function(value)
    text:set_text(value .. "%")
    volume.set_tooltip("Volume: " .. value .. "%")
  end)

  awesome.connect_signal("sound::change", function(value)
    if value == "on" then
      icon:set_text(beautiful.icon_volume)
    else
      icon:set_text(beautiful.icon_volume_mute)
    end
  end)

  awful.widget.watch([[pamixer --get-volume]], _G.configs.volume.sampling_time, function(_, stdout)
    local volume_percentage = tonumber(stdout)
    if volume_percentage ~= nil then
      awful.spawn.easy_async_with_shell([[pamixer --get-default-sink | tail -n 1]], function(o)
        local device_name = lib.utils.split(o, '"')[4]
        awesome.emit_signal("volume_popup::device", device_name) -- luacheck: no global
      end)
      text:set_text(math.ceil(volume_percentage or 0) .. "%")
      volume.set_tooltip("Volume: " .. math.ceil(volume_percentage or 0) .. "%")
      awesome.emit_signal("volume_popup::value", volume_percentage or 0) -- luacheck: no global
    end

    collectgarbage("collect")
  end)

  awful.widget.watch([[pamixer --get-mute]], _G.configs.volume.sampling_time, function(_, stdout)
    stdout = lib.utils.trim(stdout)

    if stdout == "false" then
      icon:set_text(beautiful.icon_volume)
    else
      icon:set_text(beautiful.icon_volume_mute)
    end
  end)

  return volume
end
