local awful = require("awful")
local lib = require("lib")

local _player = {}

_player.update_play_state = function(obj)
  obj = obj or {}
  awful.spawn.easy_async_with_shell([[mpc | grep playing]], function(stdout)
    stdout = lib.utils.trim(stdout)

    if string.find(stdout, "playing") then
      if obj.on_play then obj.on_play(stdout) end
    else
      if obj.on_pause then obj.on_pause(stdout) end
    end
  end)
end

_player.toggle = function(obj)
  obj = obj or {}
  awful.spawn.easy_async_with_shell([[mpc toggle]], function(stdout)
    stdout = lib.utils.trim(stdout)

    if string.find(stdout, "playing") then
      if obj.on_play then obj.on_play(stdout) end
    else
      if obj.on_pause then obj.on_pause(stdout) end
    end
  end)
end

_player.stop = function(obj)
  obj = obj or {}
  awful.spawn.easy_async_with_shell([[mpc stop]], function(stdout)
    if obj.on_stop then obj.on_stop(stdout) end
  end)
end

_player.skip = function(obj)
  obj = obj or { next = true }

  awful.spawn.easy_async_with_shell("mpc " .. (obj.next and "next" or "prev"), function(stdout)
    if obj.on_next and obj.next then
      obj.on_next(stdout)
    end
    if obj.on_prev and not obj.next then
      obj.on_prev(stdout)
    end
  end)
end

_player.get_current = function(obj)
  awful.spawn.easy_async_with_shell([[mpc current]], function(stdout)
    stdout = lib.utils.trim(stdout)

    if stdout ~= "" then
      obj.on_current(stdout)
    else
      if obj.on_obsolete then
        obj.on_obsolete(stdout)
      end
    end
  end)
end

_player.update_shuffle_state = function(obj)
  obj = obj or {}
  awful.spawn.easy_async_with_shell([[mpc | grep random | awk '{print $6}']], function(stdout)
    stdout = lib.utils.trim(stdout)

    if stdout == "on" then
      if obj.on_on then obj.on_on() end
    else
      if obj.on_off then obj.on_off() end
    end
  end)
end

_player.toggle_shuffle = function(obj)
  obj = obj or {}
  awful.spawn.easy_async_with_shell([[mpc | grep random | awk '{print $6}']], function(stdout)
    stdout = lib.utils.trim(stdout)

    if stdout == "on" then
      awful.spawn("mpc random off")
      if obj.on_off then obj.on_off() end
    else
      awful.spawn("mpc random on")
      if obj.on_on then obj.on_on() end
    end
  end)
end

_player.update_repeat_state = function(obj)
  obj = obj or {}
  awful.spawn.easy_async_with_shell([[mpc | grep repeat | awk '{print $4}']], function(stdout)
    stdout = lib.utils.trim(stdout)
    if stdout == "on" then
      if obj.on_on then obj.on_on() end
    else
      if obj.on_off then obj.on_off() end
    end
  end)
end

_player.toggle_repeat = function(obj)
  obj = obj or {}
  awful.spawn.easy_async_with_shell([[mpc | grep repeat | awk '{print $4}']], function(stdout)
    stdout = lib.utils.trim(stdout)
    if stdout == "on" then
      awful.spawn("mpc repeat off")
      if obj.on_off then obj.on_off() end
    else
      awful.spawn("mpc repeat on")
      if obj.on_on then obj.on_on() end
    end
  end)
end

return _player
