local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local apps = require("configurations.apps")
local factory = require("factory")
local lib = require("lib")
local dpi = lib.utils.dpi
local utils = lib.utils

local function create_qs_button(obj)
  local button_icon = wibox.widget({
    text = obj.icon,
    font = beautiful.icon_font .. " Round 24",
    widget = wibox.widget.textbox,
  })

  local button = factory.create_button({
    child = button_icon,
    tooltip = true,
    bg = beautiful.palette.black,
    width = dpi(80),
    height = dpi(80),
    border_radius = dpi(40),
    on_click = obj.on_click,
    on_right_click = obj.on_right_click,
  })

  button.set_icon = function(icon)
    button_icon:set_text(icon)
  end

  return button
end

return function()
  -- airplanemode
  local airplane_state = false

  local airplanemode = create_qs_button({
    icon = beautiful.icon_airplanemode_off,
    on_click = function()
      awesome.emit_signal("airplane::toggle")
    end,
  })
  airplanemode.set_tooltip("Airplane Mode: Off")

  local airplane_toggle = function()
    airplane_state = not airplane_state

    if airplane_state then
      awful.spawn("bluetoothctl power off")
      awful.spawn("nmcli n off")

      airplanemode.set_icon(beautiful.icon_airplanemode)
      airplanemode:set_bg(beautiful.palette.accent)
      airplanemode.set_tooltip("Airplane Mode: On")
    else
      awful.spawn("bluetoothctl power on")
      awful.spawn("nmcli n on")

      airplanemode.set_icon(beautiful.icon_airplanemode_off)
      airplanemode:set_bg(beautiful.palette.black)
      airplanemode.set_tooltip("Airplane Mode: Off")
    end
  end

  awesome.connect_signal("airplane::toggle", airplane_toggle)

  -- Network
  local network = create_qs_button({
    icon = beautiful.icon_network_disabled,
    on_click = function()
      awesome.emit_signal("network::toggle")
    end,
    on_right_click = function() end,
  })

  awful.widget.watch([[fish -c "nmcli n"]], _G.configs.network.sampling_time, function(_, stdout)
    stdout = utils.trim(stdout)

    if stdout == "enabled" then
      network.set_icon(beautiful.icon_network)
      network:set_bg(beautiful.palette.accent)
      awful.spawn.easy_async_with_shell([[fish -c "nmcli c | head -n 2 | tail -n 1"]], function(o)
        local arr = utils.split(o, " ")
        local interface = arr[#arr]
        local interface_type = arr[#arr - 1]
        local label = utils.trim(interface_type:gsub("^%l", string.upper) .. ": " .. interface .. " (" .. stdout .. ")")
        network.set_tooltip(label)
      end)
    else
      network.set_icon(beautiful.icon_network_disabled)
      network:set_bg(beautiful.palette.black)
      network.set_tooltip("You forgot pay the Internet bill, huh?") -- luacheck: no global
    end
  end)

  local network_toggle = function()
    awful.spawn.easy_async_with_shell(apps.utils.network .. " toggle", function(stdout)
      if stdout == "on" then
        network.set_icon(beautiful.icon_network)
        network:set_bg(beautiful.palette.accent)
        network.set_tooltip("Network loading ...") -- luacheck: no global
      else
        network.set_icon(beautiful.icon_network_disabled)
        network:set_bg(beautiful.palette.black)
        network.set_tooltip("You forgot pay the Internet bill, huh?") -- luacheck: no global
      end
    end)
  end

  awesome.connect_signal("network::toggle", network_toggle)

  -- Bluetooth
  local bluetooth = create_qs_button({
    icon = beautiful.icon_bluetooth_off,
    on_click = function()
      awesome.emit_signal("bluetooth::toggle")
    end,
    on_right_click = function() end,
  })

  awful.spawn.easy_async_with_shell(apps.utils.bluetooth .. " get_power_state", function(stdout)
    stdout = lib.utils.trim(stdout)

    if stdout == "yes" then
      bluetooth.set_icon(beautiful.icon_bluetooth)
      bluetooth:set_bg(beautiful.palette.accent)
      bluetooth.set_tooltip("Bluetooth: On")
    else
      bluetooth.set_icon(beautiful.icon_bluetooth_off)
      bluetooth:set_bg(beautiful.palette.black)
      bluetooth.set_tooltip("Bluetooth: Off")
    end
  end)

  local bluetooth_toggle = function()
    awful.spawn.easy_async_with_shell(apps.utils.bluetooth .. " toggle", function(stdout)
      stdout = lib.utils.trim(stdout)

      if stdout == "on" then
        bluetooth.set_icon(beautiful.icon_bluetooth)
        bluetooth:set_bg(beautiful.palette.accent)
        bluetooth.set_tooltip("Bluetooth: On")
      else
        bluetooth.set_icon(beautiful.icon_bluetooth_off)
        bluetooth:set_bg(beautiful.palette.black)
        bluetooth.set_tooltip("Bluetooth: Off")
      end
    end)
  end

  awesome.connect_signal("bluetooth::toggle", bluetooth_toggle)

  -- Nightlight
  local nightlight = create_qs_button({
    icon = beautiful.icon_nightlight_disabled,
    on_click = function()
      awesome.emit_signal("nightlight::toggle")
    end,
    on_right_click = function() end,
  })

  nightlight.set_tooltip("Nightlight")

  local nightlight_toggle = function()
    awful.spawn.easy_async_with_shell(apps.utils.nightlight, function(stdout)
      stdout = lib.utils.trim(stdout)

      if stdout == "false" then
        nightlight.set_icon(beautiful.icon_nightlight_disabled)
        nightlight:set_bg(beautiful.palette.black)
        nightlight.set_tooltip("Nightlight: Disabled")
      else
        nightlight.set_icon(beautiful.icon_nightlight)
        nightlight:set_bg(beautiful.palette.accent)
        nightlight.set_tooltip("Nightlight: Enabled")
      end
    end)
  end

  awesome.connect_signal("nightlight::toggle", nightlight_toggle)

  -- Sound
  local sound = create_qs_button({
    icon = beautiful.icon_volume,
    on_click = function()
      awesome.emit_signal("sound::toggle")
    end,
    on_right_click = function() end,
  })

  awful.spawn.easy_async_with_shell([[fish -c "pamixer --get-mute"]], function(stdout)
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

  -- Microphone
  local microphone = create_qs_button({
    icon = beautiful.icon_microphone,
    on_click = function()
      awesome.emit_signal("microphone::toggle")
    end,
    on_right_click = function() end,
  })

  awful.spawn.easy_async_with_shell([[fish -c "pamixer --default-source --get-mute"]], function(stdout)
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

  -- Screenshot
  local screenshot = create_qs_button({
    icon = beautiful.icon_screenshot,
    on_click = function()
      awesome.emit_signal("dashboard::toggle")
      awful.spawn(apps.utils.screenshot_screen)
    end,
  })
  screenshot.set_tooltip("Screenshot")

  -- Recorder
  local recorder = create_qs_button({
    icon = beautiful.icon_recorder,
    on_click = function()
      awful.spawn(apps.utils.screencast)
    end,
    on_right_click = function() end,
  })
  recorder.set_tooltip("Screen Recoder")

  -- QUICK SETTINGS
  local quicksettings = wibox.widget({
    {
      {
        {
          airplanemode,
          network,
          bluetooth,
          nightlight,
          spacing = dpi(48),
          widget = wibox.layout.fixed.horizontal,
        },
        {
          sound,
          microphone,
          screenshot,
          recorder,
          spacing = dpi(48),
          widget = wibox.layout.fixed.horizontal,
        },
        spacing = dpi(48),
        widget = wibox.layout.fixed.vertical,
      },
      margins = dpi(24),
      widget = wibox.container.margin,
    },
    border_width = dpi(1),
    border_color = beautiful.palette.bg4,
    shape = lib.ui.rrect(4),
    widget = wibox.container.background,
  })

  return quicksettings
end
