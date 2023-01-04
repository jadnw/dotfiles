local beautiful = require("beautiful")
local wibox = require("wibox")

local factory = require("factory")
local lib = require("lib")
local dpi = lib.utils.dpi
local player = require("modules.player")

return function()
  -- Current
  local title = wibox.widget({
    text = "Hey Jay! Let's play some catchy music.",
    font = beautiful.font,
    halign = "center",
    widget = wibox.widget.textbox,
  })

  local update_title = function()
    player.get_current({
      on_current = function(t)
        title:set_text(t)
      end,
    })
  end

  update_title()

  -- Control buttons
  -- Play/Pause
  local play_btn = factory.create_mp_button({
    icon = beautiful.icon_music_player_play,
    on_click = function()
      awesome.emit_signal("player::toggle") -- luacheck: no global
    end,
  })
  play_btn.set_tooltip("Play")

  local update_play_params = {
      on_play = function()
        play_btn.set_icon(beautiful.icon_music_player_pause)
      end,
      on_pause = function()
        play_btn.set_icon(beautiful.icon_music_player_play)
      end,
    }

  local update_play_btn = function()
    player.update_play_state(update_play_params)
  end

  update_play_btn()

  local play_pause = function()
    player.toggle(update_play_params)
    update_title()
  end

  awesome.connect_signal("player::toggle", play_pause) -- luacheck: no global

  -- Stop
  local stop_btn = factory.create_mp_button({
    icon = beautiful.icon_music_player_stop,
    on_click = function()
      player.stop({
        on_stop = function()
          play_btn.set_icon(beautiful.icon_music_player_play)
        end,
      })
    end,
  })
  stop_btn.set_tooltip("Stop")

  -- Previous
  local prev_btn = factory.create_mp_button({
    icon = beautiful.icon_music_player_prev,
    on_click = function()
      player.skip({
        next = false,
        on_prev = function()
          update_title()
          update_play_btn()
        end,
      })
    end,
  })
  prev_btn.set_tooltip("Previous")

  -- Next
  local next_btn = factory.create_mp_button({
    icon = beautiful.icon_music_player_next,
    on_click = function()
      player.skip({
        next = true,
        on_next = function()
          update_title()
          update_play_btn()
        end,
      })
    end,
  })
  next_btn.set_tooltip("Next")

  -- Shuffle
  local shuffle_btn = factory.create_mp_button({
    icon = beautiful.icon_music_player_shuffle,
    small = true,
    on_click = function()
      awesome.emit_signal("player::toggle_shuffle") -- luacheck: no global
    end,
  })
  shuffle_btn.set_tooltip("Shuffle")

  local update_shuffle_params = {
      on_on = function()
        shuffle_btn:set_fg(beautiful.palette.accent)
      end,
      on_off = function()
        shuffle_btn:set_fg(beautiful.palette.black)
      end,
    }

  local update_shuffle_btn = function()
    player.update_shuffle_state(update_shuffle_params)
  end

  update_shuffle_btn()

  local toggle_shuffle = function()
    player.toggle_shuffle(update_shuffle_params)
  end

  awesome.connect_signal("player::toggle_shuffle", toggle_shuffle) -- luacheck: no global

  -- Repeat
  local repeat_btn = factory.create_mp_button({
    icon = beautiful.icon_music_player_repeat,
    small = true,
    on_click = function()
      awesome.emit_signal("player::toggle_repeat") -- luacheck: no global
    end,
  })
  repeat_btn.set_tooltip("Repeat")

  local update_repeat_params = {
      on_on = function()
        repeat_btn:set_fg(beautiful.palette.accent)
      end,
      on_off = function()
        repeat_btn:set_fg(beautiful.palette.black)
      end,
    }

  local update_repeat_btn = function()
    player.update_repeat_state(update_repeat_params)
  end

  update_repeat_btn()

  local toggle_repeat = function()
    player.toggle_repeat(update_repeat_params)
  end

  awesome.connect_signal("player::toggle_repeat", toggle_repeat) -- luacheck: no global

  -- Music Player
  local music_player = wibox.widget({
    {
      {
        {
          title,
          fg = beautiful.palette.accent,
          widget = wibox.container.background,
        },
        {
          shuffle_btn,
          prev_btn,
          play_btn,
          stop_btn,
          next_btn,
          repeat_btn,
          spacing = dpi(44),
          layout = wibox.layout.fixed.horizontal,
        },
        spacing = dpi(16),
        layout = wibox.layout.fixed.vertical,
      },
      margins = dpi(24),
      widget = wibox.container.margin,
    },
    border_width = dpi(1),
    border_color = beautiful.palette.bg4,
    shape = lib.ui.rrect(4),
    widget = wibox.container.background,
  })

  return music_player
end
