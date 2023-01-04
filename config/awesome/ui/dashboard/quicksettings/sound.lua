local awful = require("awful")
local beautiful = require("beautiful")

local apps = require("configurations.apps")
local factory = require("factory")
local lib = require("lib")

return function()
  local sound = factory.create_qs_button({
    icon = beautiful.icon_volume,
    on_click = function()
      awesome.emit_signal("sound::toggle") -- luacheck: no global
    end,
    on_right_click = function() end,
  })

  local update_sound = function(value)
    value = lib.utils.trim(value)

    if value == "on" then
      sound.set_icon(beautiful.icon_volume)
      sound:set_bg(beautiful.palette.accent)
      sound.set_tooltip("Sound: Enabled")
    else
      sound.set_icon(beautiful.icon_volume_mute)
      sound:set_bg(beautiful.palette.black)
      sound.set_tooltip("Sound: Muted")
    end

    awesome.emit_signal("sound::change", value)
  end

  awful.widget.watch(apps.utils.sound .. " get_sink_state", _G.configs.volume.sampling_time, function(_, stdout) update_sound(stdout) end)

  local toggle_mute = function()
    awful.spawn.easy_async_with_shell(apps.utils.sound .. " toggle_sink", update_sound)
  end

  awesome.connect_signal("sound::toggle", toggle_mute)

  return sound
end
