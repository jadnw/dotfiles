local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local dpi = require("lib.utils").dpi
local factory = require("factory")
local apps = require("configurations.apps")

return function()
  local sysguard_label = wibox.widget({
    {
      id = "icon",
      text = beautiful.icon_sysguard,
      font = beautiful.icon_font .. " Round 16",
      widget = wibox.widget.textbox,
    },
    {
      id = "text",
      text = "Calculating ...",
      font = beautiful.font .. " Semibold 11",
      widget = wibox.widget.textbox,
    },
    spacing = dpi(6),
    layout = wibox.layout.fixed.horizontal,
  })

  local icon = sysguard_label:get_children_by_id("icon")[1]
  local text = sysguard_label:get_children_by_id("text")[1]

  local sysguard = factory.create_button({
    child = sysguard_label,
    tooltip = true,
    padding_right = dpi(10),
    bg = beautiful.palette.purple,
    on_click = function()
      awesome.emit_signal("dashboard::toggle") -- luacheck: no global
    end,
    on_right_click = function()
      awful.spawn(apps.default.system_monitor)
    end,
  })

  sysguard.set_tooltip("System load: Calculating ...")

  local total_prev = 0
  local idle_prev = 0

  awful.widget.watch(
    [[cat /proc/stat | grep '^cpu ']],
    _G.configs.sysguard.sampling_time,
    function(_, stdout)
      local user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice = -- luacheck: no unused
        stdout:match("(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s")

      local total = user + nice + system + idle + iowait + irq + softirq + steal
      local diff_idle = idle - idle_prev
      local diff_total = total - total_prev
      local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10

      total_prev = total
      idle_prev = idle

      -- Calculate memory usage
      awful.spawn.easy_async_with_shell([[fish -c "free | grep '^Mem'"]], function(out)
        local total_mem, used_mem, free_mem, shared_mem, buff_cache_mem, available_mem = -- luacheck: no unused
          out:match("(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)")
        local percentage = used_mem / total_mem * 100
        local bytes_per_gigabytes = 1024 * 1024

        icon:set_text(
          (diff_usage > 75 or percentage > 75) and beautiful.icon_sysguard_warning or beautiful.icon_sysguard
        )
        text:set_text("CPU: " .. math.ceil(diff_usage) .. "%  MEM: " .. math.ceil(percentage) .. "%")
        sysguard.set_tooltip(
          "CPU Usage: "
            .. math.ceil(diff_usage)
            .. "%  Memory Usage: "
            .. math.ceil(percentage)
            .. "%  Memory Used: "
            .. math.ceil(used_mem / bytes_per_gigabytes)
            .. "G/"
            .. math.ceil(total_mem / bytes_per_gigabytes)
            .. "G"
        )
      end)

      collectgarbage("collect")
    end
  )

  return sysguard
end
