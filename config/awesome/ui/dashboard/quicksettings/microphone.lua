local awful = require("awful")
local beautiful = require("beautiful")

local apps = require("configurations.apps")
local factory = require("factory")
local lib = require("lib")

return function()
  local microphone = factory.create_qs_button({
    icon = beautiful.icon_microphone,
    on_click = function()
      awesome.emit_signal("microphone::toggle")
    end,
    on_right_click = function() end,
  })

  awful.widget.watch(
    [[pamixer --default-source --get-mute]],
    _G.configs.microphone.sampling_time,
    function(_, stdout)
      stdout = lib.utils.trim(stdout)

      if stdout == "false" then
        microphone.set_icon(beautiful.icon_microphone)
        microphone:set_bg(beautiful.palette.accent)
        microphone.set_tooltip("Microphone: Enabled")
      else
        microphone.set_icon(beautiful.icon_microphone_off)
        microphone:set_bg(beautiful.palette.black)
        microphone.set_tooltip("Microphone: Muted")
      end
    end
  )

  local toggle_microphone_mute = function()
    awful.spawn.easy_async_with_shell(apps.utils.sound .. " toggle_source", function(stdout)
      stdout = lib.utils.trim(stdout)

      if stdout == "false" then
        microphone.set_icon(beautiful.icon_microphone)
        microphone:set_bg(beautiful.palette.accent)
        microphone.set_tooltip("Microphone: Enabled")
      else
        microphone.set_icon(beautiful.icon_microphone_off)
        microphone:set_bg(beautiful.palette.black)
        microphone.set_tooltip("Microphone: Muted")
      end
    end)
  end

  awesome.connect_signal("microphone::toggle", toggle_microphone_mute)

  return microphone
end
