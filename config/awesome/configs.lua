local beautiful = require("beautiful")

-- Notifications
_G.nightlight_enabled = false
_G.dnd_enable = false
_G.notifications = {}

-- User defined configs
_G.configs = {
  sysguard = {
    sampling_time = 60,
    cpu_sampling_time = 30,
    memory_sampling_time = 30,
    temp_sampling_time = 30,
    disk_sampling_time = 300,
  },
  network = {
    sampling_time = 60,
  },
  bluetooth = {
    sampling_time = 60,
  },
  volume = {
    sampling_time = 60,
  },
  microphone = {
    sampling_time = 60,
  },
  nightlight = {
    sampling_time = 60,
  },
  joke = {
    sampling_time = 3600,
    endpoint = "https://v2.jokeapi.dev/joke/Programming?format=txt",
  },
  -- for notification icons and colors
  notifications = {
    apps = {
      ["screenshot tool"] = { icon = "", color = beautiful.palette.yellow },
      ["screencast tool"] = { icon = "", color = beautiful.palette.magenta },
      ["color picker"] = { icon = "", color = beautiful.palette.cyan },
    },
  },
}
