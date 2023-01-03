local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local apps = require("configurations.apps")
local factory = require("factory")
local lib = require("lib")
local dpi = lib.utils.dpi

local function create_cpu_progress()
  local cpu = factory.create_dashboard_circular_progress({
    tooltip = true,
    icon = beautiful.icon_cpu,
    icon_color = beautiful.palette.blue,
    min_value = 0,
    max_value = 100,
    ring_color = beautiful.palette.blue,
    on_click = function()
      lib.run.run_once_grep(apps.default.system_monitor)
    end,
  })

  cpu.set_tooltip("CPU Usage")

  local total_prev = 0
  local idle_prev = 0

  awful.widget.watch(
    [[cat /proc/stat | grep '^cpu ']],
    _G.configs.sysguard.cpu_sampling_time,
    function(_, stdout)
      local user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice = -- luacheck: no unused
        stdout:match("(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s")

      local total = user + nice + system + idle + iowait + irq + softirq + steal
      local diff_idle = idle - idle_prev
      local diff_total = total - total_prev
      local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10

      cpu:set_value(diff_usage)
      cpu.set_tooltip("Your system load at " .. math.ceil(diff_usage) .. "%")
      total_prev = total
      idle_prev = idle
      collectgarbage("collect")
    end
  )

  return cpu
end

local function create_memory_progress()
  local memory = factory.create_dashboard_circular_progress({
    tooltip = "Memory Usage",
    icon = beautiful.icon_memory,
    icon_color = beautiful.palette.teal,
    min_value = 0,
    max_value = 100,
    ring_color = beautiful.palette.teal,
    on_click = function()
      lib.run.run_once_grep(apps.default.system_monitor)
    end,
  })

  awful.widget.watch(
    [[fish -c "free | grep '^Mem'"]],
    _G.configs.sysguard.memory_sampling_time,
    function(_, stdout)
      local total, used, free, shared, buff_cache, available = -- luacheck: no unused
        stdout:match("(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)")
      local percentage = used / total * 100
      local bytes_per_gigabytes = 1024 * 1024
      memory:set_value(percentage)
      memory.set_tooltip(
        "You used <b>"
          .. math.ceil(percentage)
          .. "%</b> ("
          .. math.ceil(used / bytes_per_gigabytes)
          .. "G/"
          .. math.ceil(total / bytes_per_gigabytes)
          .. "G) of your memory."
      )
      collectgarbage("collect")
    end
  )

  return memory
end

local function create_disk_progress()
  local disk = factory.create_dashboard_circular_progress({
    tooltip = "Disk Usage",
    icon = beautiful.icon_disk,
    icon_color = beautiful.palette.yellow,
    min_value = 0,
    max_value = 100,
    ring_color = beautiful.palette.yellow,
    on_click = function()
      lib.run.run_once_grep(apps.default.system_monitor)
    end,
  })

  awful.widget.watch(
    [[df -h /home | grep '^/']],
    _G.configs.sysguard.disk_sampling_time,
    function(_, stdout)
      local disk_id, total, used, available, percentage = stdout:match("(%d+)%s*(%d+)G%s*(%d+)G%s*(%d+)G%s*(%d+)")

      percentage = tonumber(percentage)
      disk:set_value(percentage)
      disk.set_tooltip("You used <b>" .. percentage .. "%</b> (" .. used .. "G/" .. total .. "G) of your SSD")

      collectgarbage("collect")
    end
  )

  return disk
end

local function create_thermostat_progress()
  local thermostat = factory.create_dashboard_circular_progress({
    tooltip = "Thermostat",
    icon = beautiful.icon_temp,
    icon_color = beautiful.palette.red,
    min_value = 0,
    max_value = 100,
    ring_color = beautiful.palette.red,
    on_click = function()
      lib.run.run_once_grep(apps.default.system_monitor)
    end,
  })

  awful.widget.watch(
    [[fish -c "sensors | grep '^edge' | awk '{print $2}'"]],
    _G.configs.sysguard.temp_sampling_time,
    function(_, stdout)
      local cpu_temp = tonumber(stdout:match("(%d+)"))

      thermostat:set_value(cpu_temp)
      thermostat.set_tooltip("Girl, you're so hot. You are " .. cpu_temp .. "C.")

      collectgarbage("collect")
    end
  )

  return thermostat
end

return function()
  local cpu_progress = create_cpu_progress()
  local memory_progress = create_memory_progress()
  local disk_progress = create_disk_progress()
  local thermostat_progress = create_thermostat_progress()

  local sysguard = wibox.widget({
    {
      {
        cpu_progress,
        memory_progress,
        disk_progress,
        thermostat_progress,
        spacing = dpi(56),
        layout = wibox.layout.fixed.horizontal,
      },
      margins = dpi(24),
      widget = wibox.container.margin,
    },
    border_width = dpi(1),
    border_color = beautiful.palette.bg4,
    shape = lib.ui.rrect(4),
    widget = wibox.container.background,
  })

  return sysguard
end
