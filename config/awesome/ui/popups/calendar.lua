local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local factory = require("factory")
local lib = require("lib")
local dpi = require("lib.utils").dpi

return function(s)
  local default_shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, dpi(2))
  end

  local styles = {
    month = {
      padding = 5,
      shape = lib.ui.rrect(beautiful.border_radius),
    },
    normal = {
      shape = default_shape,
    },
    focus = {
      fg_color = beautiful.palette.bg0,
      bg_color = beautiful.palette.fg0,
      markup = function(t)
        return "<b>" .. t .. "</b>"
      end,
      shape = default_shape,
    },
    header = {
      fg_color = beautiful.palette.fg0,
    },
    weekday = {
      fg_color = beautiful.palette.fg3,
    },
  }

  local decorate_cell = function(widget, flag, date)
    if flag == "monthheader" and not styles.monthheader then
      flag = "header"
    end
    local props = styles[flag] or {}
    if props.markup and widget.get_text and widget.set_markup then
      widget:set_markup(props.markup(widget:get_text()))
    end
    -- Change bg color for weekends
    local d = { year = date.year, month = (date.month or 1), day = (date.day or 1) }
    local weekday = tonumber(os.date("%w", os.time(d)))
    local default_fg = (weekday == 0) and beautiful.palette.red or beautiful.palette.fg1
    local ret = wibox.widget({
      {
        {
          widget,
          margins = (props.padding or 2) + (props.border_width or 0),
          widget = wibox.container.margin,
        },
        valign = "center",
        halign = "center",
        widget = wibox.container.place,
      },
      shape = props.shape,
      shape_border_color = props.border_color or beautiful.palette.red,
      shape_border_width = props.border_width or 0,
      fg = props.fg_color or default_fg,
      bg = props.bg_color or beautiful.palette.transparent,
      widget = wibox.container.background,
    })
    return ret
  end

  local calendar = wibox.widget({
    date = os.date("*t"),
    font = beautiful.font_family .. " Semibold 11",
    spacing = dpi(12),
    long_weekdays = true,
    fn_embed = decorate_cell,
    widget = wibox.widget.calendar.month,
  })

  -- Create buttons
  local prev_month = factory.create_button({
    child = {
      text = "",
      font = beautiful.icon_font .. " Round 16",
      widget = wibox.widget.textbox,
    },
    fg_hover = beautiful.palette.fg0,
    fg = beautiful.palette.fg3,
    on_click = function()
      local date = calendar:get_date()
      calendar:set_date({
        month = date.month - 1,
        year = date.year,
      })
    end,
  })
  local this_month = factory.create_button({
    child = {
      {
        text = "",
        font = beautiful.icon_font .. " Round 14",
        widget = wibox.widget.textbox,
      },
      halign = "center",
      widget = wibox.container.place,
    },
    fg = beautiful.palette.fg3,
    fg_hover = beautiful.palette.fg0,
    on_click = function()
      calendar:set_date(os.date("*t"))
    end,
  })
  local next_month = factory.create_button({
    child = {
      text = "",
      font = beautiful.icon_font .. " Round 16",
      widget = wibox.widget.textbox,
    },
    fg_hover = beautiful.palette.fg0,
    fg = beautiful.palette.fg3,
    on_click = function()
      local date = calendar:get_date()
      calendar:set_date({
        month = date.month + 1,
        year = date.year,
      })
    end,
  })

  local calendar_popup = factory.create_popup({
    screen = s,
    child = {
      {
        nil,
        {
          calendar,
          forced_height = dpi(300),
          layout = wibox.layout.fixed.vertical,
        },
        {
          prev_month,
          {
            nil,
            this_month,
            nil,
            layout = wibox.layout.align.horizontal,
          },
          next_month,
          layout = wibox.layout.align.horizontal,
        },
        layout = wibox.layout.fixed.vertical,
      },
      valign = "top",
      widget = wibox.container.place,
    },
    placement = function(w)
      awful.placement.bottom_right(w, {
        margins = {
          right = beautiful.useless_gap + dpi(2),
          bottom = beautiful.wibar_height + beautiful.useless_gap + dpi(2),
        },
      })
    end,
    width = dpi(320),
    height = dpi(360),
  })

  calendar_popup.toggle_visible_and_refresh = function()
    calendar_popup.toggle_visible()
    if calendar_popup.visible then
      calendar:set_date(os.date("*t"))
    end
  end

  -- Signals
  awesome.connect_signal("calendar_popup::toggle", calendar_popup.toggle_visible_and_refresh)

  return calendar_popup
end
