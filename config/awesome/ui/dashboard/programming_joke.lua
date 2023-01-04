local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")

local lib = require("lib")
local dpi = lib.utils.dpi

return function()
  local programming_joke = wibox.widget({
    {
      {
        {
          {
            text = "I got you!",
            font = beautiful.font_family .. " Bold 11",
            widget = wibox.widget.textbox,
          },
          fg = beautiful.palette.accent,
          widget = wibox.container.background,
        },
        {
          {
            id = "text",
            text = "This is the funniest joke ever.",
            line_spacing_factor = 1.4,
            font = beautiful.font,
            widget = wibox.widget.textbox,
          },
          step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
          fps = 30,
          speed = 30,
          forced_height = dpi(124),
          widget = wibox.container.scroll.vertical,
        },
        spacing = dpi(16),
        widget = wibox.layout.fixed.vertical,
      },
      margins = dpi(24),
      widget = wibox.container.margin,
    },
    border_width = dpi(1),
    border_color = beautiful.palette.bg4,
    shape = lib.ui.rrect(4),
    forced_width = dpi(480),
    widget = wibox.container.background,
  })

  local text = programming_joke:get_children_by_id("text")[1]

  awful.widget.watch(
    [[curl -s ']] .. _G.configs.joke.endpoint .. [[']],
    _G.configs.joke.sampling_time,
    function(_, stdout)
      stdout = lib.utils.trim(stdout)
      text:set_text(gears.string.linewrap(stdout, 66))
    end
  )

  return programming_joke
end
