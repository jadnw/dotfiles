local awful = require("awful")
local beautiful = require("beautiful")

local apps = require("configurations.apps")
local factory = require("factory")
local lib = require("lib")

return function()
  local sound = factory.create_qs_button({
    icon = beautiful.icon_volume,
    on_click = function()
      awesome.emit_signal("sound::toggle")
    end,
    on_right_click = function() end,
  })

  awful.widget.watch([[pamixer --get-mute]], _G.configs.volume.sampling_time, function(_, stdout)
    stdout = lib.utils.trim(stdout)

    if stdout == "false" then
      sound.set_icon(beautiful.icon_volume)
      sound:set_bg(beautiful.palette.accent)
      sound.set_tooltip("Sound: Enabled")
    else
      sound.set_icon(beautiful.icon_volume_mute)
      sound:set_bg(beautiful.palette.black)
      sound.set_tooltip("Sound: Muted")
    end
  end)

  local toggle_mute = function()
    awful.spawn.easy_async_with_shell(apps.utils.sound .. " toggle", function(stdout)
      stdout = lib.utils.trim(stdout)

      if stdout == "false" then
        sound.set_icon(beautiful.icon_volume)
        sound:set_bg(beautiful.palette.accent)
        sound.set_tooltip("Sound: Enabled")
      else
        sound.set_icon(beautiful.icon_volume_mute)
        sound:set_bg(beautiful.palette.black)
        sound.set_tooltip("Sound: Muted")
      end
    end)
  end

  awesome.connect_signal("sound::toggle", toggle_mute)

  return sound
end
