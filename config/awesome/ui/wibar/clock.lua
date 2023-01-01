local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local lib = require("lib")
local dpi = require("lib.utils").dpi

return function(s)
  require("ui.popups.calendar")(s)

  local clock = wibox.widget({
    {
      {
        {
          format = "%H:%M",
          refresh = 60,
          font = beautiful.font_family .. " Bold 14",
          widget = wibox.widget.textclock,
        },
        left = dpi(8),
        right = dpi(8),
        widget = wibox.container.margin,
      },
      margins = dpi(2),
      widget = wibox.container.margin,
    },
    shape = lib.ui.rrect(beautiful.border_radius),
    bg = beautiful.palette.fg0,
    widget = wibox.container.background,
  })

  lib.ui.add_hover_cursor(clock)

  clock:buttons(gears.table.join(awful.button({}, 1, function()
    awesome.emit_signal("calendar_popup::toggle") -- luacheck: no global
  end)))

  awful.tooltip({
    objects = { clock },
    markup = os.date("Today is %B %d, %Y"),
  })

  return clock
end
