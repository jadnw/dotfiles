local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")
local wibox = require("wibox")
local dpi = require("lib.utils").dpi

local lib = require("lib")
local animation = require("lib.animation")
local utils = require("lib.utils")

local _factory = {}

--- Create a popup menu
----------------------------------------------------------------------------------------------------
-- @obj: The object to define the popup menu
---- screen (awful.screen): The screen to show the popup menu
---- child (awful.widget): The widget to wrap arounds
---- padding (number): The padding
---- bg (string): The background color
---- placement (awful.placement): The position of the popup menu
---- shape (gears.shape): The shape of the popup menu
---- visible (boolean): Show/Unshow the popup menu
---- width (number): The popup menu width
---- height (number): The popup menu height
_factory.create_popup = function(obj)
  local popup_config = {
    type = "popup_menu",
    screen = obj.screen or awful.screen.focused(),
    widget = {
      obj.child,
      margins = obj.padding or dpi(16),
      widget = wibox.container.margin,
    },
    placement = obj.placement or awful.placement.bottom_left,
    shape = obj.shape or lib.ui.rrect(beautiful.border_radius),
    visible = obj.visible or false,
    bg = obj.bg or beautiful.popup_bg,
    ontop = true,
    minimum_height = obj.height and dpi(obj.height) or nil,
    maximum_height = obj.height and dpi(obj.height) or nil,
    minimum_width = obj.width and dpi(obj.width) or nil,
    maximum_width = obj.width and dpi(obj.width) or nil,
  }
  local popup = awful.popup(popup_config)

  popup.toggle_visible = function()
    popup.visible = not popup.visible
  end

  -- Implement right click to close popup
  popup.buttons = gears.table.join(awful.button({}, 3, popup.toggle_visible))

  return popup
end

--- Create a button widget
----------------------------------------------------------------------------------------------------
-- @obj (table): The object to define the button
---- child (wibox.widget): The widget to wrap arounds
---- width (number): The width
---- height (number): The height
---- padding (number): The button padding value for all sides
---- padding_{top/left/right/bottom} (number): The button padding values
---- border_radius (number): The border radius
---- bg (gears.color or string): The background color
---- bg_hover (gears.color or string): The background color on hover
---- fg (gears.color or string): The foreground color
---- fg_hover (gears.color or string): The foreground color on hover
---- border_width(number): The button border width
---- border_color(gears.color or string): The button border color
---- tooltip (bool): Enable/Disable tooltip on hover (default false)
---- on_click (function): The function to execute when the widget on left click
---- on_right_click (function): The function to execute when the widget on right click
---- on_scroll_up (function): The function to execute when the widget on scroll up
---- on_scroll_down (function): The function to execute when the widget on scroll down
-- @return the button widget
_factory.create_button = function(obj)
  local button = wibox.widget({
    {
      {
        obj.child,
        halign = "center",
        valign = "center",
        widget = wibox.container.place,
      },
      top = obj.padding_top or dpi(6),
      bottom = obj.padding_bottom or dpi(6),
      left = obj.padding_left or dpi(6),
      right = obj.padding_right or dpi(6),
      margins = obj.padding or nil,
      widget = wibox.container.margin,
    },
    bg = obj.bg or beautiful.palette.transparent,
    fg = obj.fg or beautiful.palette.bg1,
    shape = lib.ui.rrect(obj.border_radius or beautiful.border_radius),
    border_width = obj.border_width or 0,
    border_color = obj.border_color or beautiful.palette.transparent,
    forced_width = obj.width or nil,
    forced_height = obj.height or nil,
    widget = wibox.container.background,
  })

  -- Hover effects
  button:connect_signal("mouse::enter", function(c)
    if obj.bg_hover then
      c:set_bg(obj.bg_hover)
    end

    if obj.fg_hover then
      c:set_fg(obj.fg_hover)
    end
  end)
  button:connect_signal("mouse::leave", function(c)
    if obj.bg_hover then
      c:set_bg(obj.bg)
    end

    if obj.fg_hover then
      c:set_fg(obj.fg)
    end
  end)

  lib.ui.add_hover_cursor(button)

  -- Add button tooltip
  local tooltip = nil
  if obj.tooltip then
    tooltip = awful.tooltip({
      objects = { button },
    })
  end

  -- Methods
  button.set_tooltip = function(markup)
    if tooltip then
      tooltip:set_markup(markup)
    end
  end

  -- Add signal click handlers
  button:buttons(
    gears.table.join(
      obj.on_click and awful.button({}, 1, obj.on_click) or nil,
      obj.on_right_click and awful.button({}, 3, obj.on_right_click) or nil,
      obj.on_scroll_up and awful.button({}, 4, obj.on_scroll_up) or nil,
      obj.on_scroll_down and awful.button({}, 5, obj.on_scroll_down) or nil
    )
  )

  return button
end

--- Create a circular button on dashboard quicksettings
----------------------------------------------------------------------------------------------------
-- @obj (table): The object to define a quicksettings button
---- icon (string): The icon
---- on_click (function): The function executed on click
---- on_right_click (function): The function executed on right click
-- @return The widget
_factory.create_qs_button = function(obj)
  local button_icon = wibox.widget({
    text = obj.icon,
    font = beautiful.icon_font .. " Round 24",
    widget = wibox.widget.textbox,
  })

  local button = _factory.create_button({
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

--- Create a music player button on music player
----------------------------------------------------------------------------------------------------
-- @obj (table): The object to define a button
---- icon (string): The icon
---- small (boolean): True if the button is small
---- on_click (function): The function executed on click
---- on_right_click (function): The function executed on right click
-- @return The widget
_factory.create_mp_button = function(obj)
  local icon_size = obj.small and 12 or 24

  local button_icon = wibox.widget({
    text = obj.icon,
    font = beautiful.icon_font .. " Round " .. icon_size,
    widget = wibox.widget.textbox,
  })

  local button = _factory.create_button({
    child = button_icon,
    tooltip = true,
    bg = beautiful.palette.transparent,
    fg = obj.small and beautiful.palette.black or beautiful.palette.fg1,
    width = dpi(44),
    height = dpi(44),
    border_radius = dpi(4),
    on_click = obj.on_click,
    on_right_click = obj.on_right_click,
  })

  button.set_icon = function(icon)
    button_icon:set_text(icon)
  end

  return button
end

--- Create a dashboard circular progress widget
----------------------------------------------------------------------------------------------------
-- @obj (table): The object to define the circular progress widget
---- child (widget): The widget to wrap arounds instead of the icon
---- icon (string): The text icon
---- radius (number): The radius of the circle (default 32)
---- min_value (number): The minimum value
---- max_value (number): The maximum value
---- value (number): The value
---- thickness (number): The thickness of the progress bar (default 4)
---- padding (number or table): The padding value of all sides (default 0)
---- icon_color (gears.color or string): The color of the icon (default beautiful.palette.fg3)
---- ring_color (gears.color or string): The active color of progress bar (default beautiful.palette.fg1)
---- ring_color_dim (gears.color or string): The inactive color of progress bar (default beautiful.palette.bg4)
---- tooltip (boolean): Enable/Disable tooltip (default false)
---- on_click (function): The function to execute when the widget on left click
---- on_right_click (function): The function to execute when the widget on right click
---- on_scroll_up (function): The function to execute when the widget on scroll up
---- on_scroll_down (function): The function to execute when the widget on scroll down
-- @return the circular progress widget
_factory.create_dashboard_circular_progress = function(obj)
  obj = obj or {}
  local default_child = wibox.widget({
    {
      {
        text = obj.icon,
        font = beautiful.icon_font .. " Round 28",
        widget = wibox.widget.textbox,
      },
      fg = obj.icon_color or beautiful.palette.fg3,
      widget = wibox.container.background,
    },
    widget = wibox.container.place,
  })
  local child = obj.child or default_child
  local circular_progress = wibox.widget({
    child,
    min_value = obj.min_value,
    max_value = obj.max_value,
    value = obj.value,
    bg = obj.ring_color_dim or beautiful.palette.bg4,
    colors = { obj.ring_color or beautiful.palette.fg1 },
    start_angle = 3 * math.pi / 2,
    thickness = obj.thickness or dpi(8),
    rounded_edge = true,
    paddings = obj.padding or 0,
    forced_width = obj.radius and obj.radius * 2 or dpi(80),
    forced_height = obj.radius and obj.radius * 2 or dpi(80),
    widget = wibox.container.arcchart,
  })

  -- Hover effects
  lib.ui.add_hover_cursor(circular_progress)

  -- Add button tooltip
  local tooltip = nil
  if obj.tooltip then
    tooltip = awful.tooltip({
      objects = { circular_progress },
    })
  end

  -- Methods
  circular_progress.set_tooltip = function(markup)
    if tooltip then
      tooltip:set_markup(markup)
    end
  end

  -- Add handlers
  circular_progress:buttons(
    gears.table.join(
      awful.button({}, 1, obj.on_click),
      awful.button({}, 3, obj.on_right_click),
      awful.button({}, 4, obj.on_scroll_up),
      awful.button({}, 5, obj.on_scroll_down)
    )
  )

  return circular_progress
end

--- Create a slider widget
----------------------------------------------------------------------------------------------------
-- @obj: The object to define the slider
---- id (string): The widget id
---- icon (string): The text icon of the slider
---- value (number): The initial value of the slider
---- active_color (string): The active color of the slider bar
---- bar_height (number): The height of the slider bar
---- handle_width (number): The width of the slider handle
---- on_change (function): The function to execute when the value is changed (the value passed)
_factory.create_slider = function(obj)
  local slider = wibox.widget({
    id = obj.id,
    value = obj.value or 100,
    shape = gears.shape.rounded_bar,
    bar_shape = gears.shape.rounded_bar,
    bar_color = beautiful.palette.bg2,
    bar_height = obj.bar_height or dpi(4),
    bar_active_color = obj.active_color or beautiful.palette.accent,
    handle_color = obj.active_color or beautiful.palette.accent,
    handle_shape = gears.shape.circle,
    handle_width = obj.handle_width or dpi(12),
    -- handle_border_width = dpi(0),
    -- handle_border_color = beautiful.palette.accent,
    maximum = 100,
    widget = wibox.widget.slider,
  })

  -- Show the percentage
  local percentage = wibox.widget({
    text = "100%",
    font = beautiful.font,
    widget = wibox.widget.textbox,
  })

  local container = wibox.widget({
    {
      {
        {
          text = obj.icon or "",
          font = beautiful.icon_font .. " Round 14",
          widget = wibox.widget.textbox,
        },
        widget = wibox.container.place,
      },
      shape = gears.shape.circle,
      fg = obj.active_color or beautiful.palette.accent,
      bg = beautiful.palette.bg1,
      forced_width = dpi(28),
      forced_height = dpi(28),
      widget = wibox.container.background,
    },
    {
      slider,
      left = dpi(12),
      right = dpi(12),
      widget = wibox.container.margin,
    },
    {
      percentage,
      forced_width = dpi(32),
      widget = wibox.container.place,
    },
    layout = wibox.layout.align.horizontal,
  })

  -- Execute a function when the value is changed
  slider:connect_signal("property::value", function()
    local value = slider:get_value()
    if obj.on_change then
      obj.on_change(value)
    end
    percentage:set_text(value .. "%")
  end)

  slider:buttons(gears.table.join(
    awful.button({}, 4, function()
      local value = slider:get_value()
      slider:set_value(value + 5)
    end),
    awful.button({}, 5, function()
      local value = slider:get_value()
      slider:set_value(value - 5)
    end)
  ))

  container.set_value = function(val)
    slider:set_value(val)
  end

  return container
end

--- Create a notification
----------------------------------------------------------------------------------------------------
-- @n (naughty.notification): The notification passed to widget
_factory.create_notification = function(n)
  local app = utils.get_n_app(n.app_name)

  -- App Icon
  local app_icon_n = wibox.widget({
    {
      font = beautiful.icon_font .. " Round 24",
      text = app.icon or "",
      widget = wibox.widget.textbox,
    },
    fg = app.color or beautiful.palette.accent,
    shape = gears.shape.circle,
    widget = wibox.container.background,
  })

  if n.icon then
    app_icon_n = nil
  end

  local icon = wibox.widget({
    {
      {
        {
          {
            image = n.icon,
            resize = true,
            clip_shape = gears.shape.circle,
            halign = "center",
            valign = "center",
            widget = wibox.widget.imagebox,
          },
          margins = dpi(4),
          widget = wibox.container.margin,
        },
        bg = beautiful.palette.bg2,
        shape = gears.shape.circle,
        widget = wibox.container.background,
      },
      strategy = "exact",
      height = dpi(48),
      width = dpi(48),
      widget = wibox.container.constraint,
    },
    {
      app_icon_n,
      widget = wibox.container.place,
    },
    layout = wibox.layout.stack,
  })

  local _app_name = n.app_name ~= "notify-send" and n.app_name or "System Notification"
  local app_name = wibox.widget({
    text = _app_name:gsub("^%l", string.upper),
    font = beautiful.font_family .. " Bold 11",
    widget = wibox.widget.textbox,
  })

  local dismiss = wibox.widget({
    {
      {
        text = "",
        font = beautiful.icon_font .. " Round 12",
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox,
      },
      fg = beautiful.notification_dismiss,
      widget = wibox.container.background,
    },
    forced_width = dpi(24),
    forced_height = dpi(24),
    max_value = 100,
    min_value = 0,
    value = 0,
    thickness = dpi(3),
    rounded_edge = true,
    bg = beautiful.notification_bg,
    colors = {
      {
        type = "linear",
        from = { 0, 0 },
        to = { 400, 400 },
        stops = {
          { 0, beautiful.palette.red },
          { 0.2, beautiful.palette.orange },
          { 0.4, beautiful.palette.yellow },
          { 0.6, beautiful.palette.green },
          { 0.8, beautiful.palette.teal },
        },
      },
    },
    buttons = {
      awful.button({}, 1, function()
        n:destroy(naughty.notification_closed_reason.dismissed_by_user)
      end),
    },
    widget = wibox.container.arcchart,
  })

  -- Change cursor on dismiss button hover
  lib.ui.add_hover_cursor(dismiss)

  local title = wibox.widget({
    {
      text = n.title,
      font = beautiful.font_family .. " Bold 11",
      widget = wibox.widget.textbox,
    },
    step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
    fps = 60,
    speed = 75,
    widget = wibox.container.scroll.horizontal,
  })

  local message = wibox.widget({
    {
      {
        text = n.message,
        font = beautiful.notification_font,
        widget = wibox.widget.textbox,
      },
      fg = beautiful.palette.fg3,
      widget = wibox.widget.background,
    },
    step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
    fps = 60,
    speed = 75,
    widget = wibox.container.scroll.horizontal,
  })

  local action_button = {
    {
      {
        {
          id = "text_role",
          font = beautiful.notification_font,
          widget = wibox.widget.textbox,
        },
        top = dpi(4),
        bottom = dpi(4),
        widget = wibox.container.margin,
      },
      widget = wibox.container.place,
    },
    bg = beautiful.palette.bg2,
    widget = wibox.container.background,
  }

  local actions = wibox.widget({
    notification = n,
    base_layout = wibox.widget({
      spacing = dpi(3),
      layout = wibox.layout.flex.horizontal,
    }),
    widget_template = action_button,
    style = {
      underline_normal = false,
      underline_selected = true,
    },
    widget = naughty.list.actions,
  })

  local box = wibox.widget({
    {
      layout = wibox.layout.fixed.vertical,
      {
        {
          {
            layout = wibox.layout.align.horizontal,
            app_name,
            nil,
            dismiss,
          },
          margins = { top = dpi(5), bottom = dpi(5), left = dpi(15), right = dpi(15) },
          widget = wibox.container.margin,
        },
        bg = beautiful.notification_bg_alt,
        widget = wibox.container.background,
      },
      {
        {
          layout = wibox.layout.fixed.vertical,
          {
            icon,
            {
              nil,
              {
                title,
                message,
                spacing = dpi(4),
                layout = wibox.layout.fixed.vertical,
              },
              nil,
              expand = "none",
              layout = wibox.layout.align.vertical,
            },
            spacing = dpi(16),
            layout = wibox.layout.fixed.horizontal,
          },
          {
            lib.ui.vertical_pad(dpi(10)),
            {
              actions,
              shape = lib.ui.rrect(beautiful.border_radius / 2),
              widget = wibox.container.background,
            },
            visible = n.actions and #n.actions > 0,
            layout = wibox.layout.fixed.vertical,
          },
        },
        margins = dpi(10),
        widget = wibox.container.margin,
      },
    },
    --- Anti-aliasing container
    shape = lib.ui.rrect(beautiful.border_radius),
    bg = beautiful.notification_bg,
    widget = wibox.container.background,
  })

  -- Animation timeout arc
  local anim = animation:new({
    duration = n.timeout,
    target = 100,
    easing = animation.easing.linear,
    reset_on_top = false,
    update = function(self, pos)
      dismiss.value = pos
    end,
  })

  anim:connect_signal("ended", function()
    n:destroy(naughty.notification_closed_reason.silent)
  end)

  box:connect_signal("mouse::enter", function()
    n:set_timeout(4294967)
    anim:stop()
  end)

  box:connect_signal("mouse::leave", function()
    anim:start()
  end)

  anim:start()

  return box
end

--- Create a notification item (on Notifications Center)
----------------------------------------------------------------------------------------------------
-- @n (naughty.notification): The notification passed to the widget
_factory.create_notification_box = function(n, i, on_remove)
  local app = utils.get_n_app(n.app_name)

  -- App Icon
  local app_icon_n = wibox.widget({
    {
      font = beautiful.icon_font .. " Round 24",
      text = app.icon or "",
      widget = wibox.widget.textbox,
    },
    fg = app.color or beautiful.palette.accent,
    shape = gears.shape.circle,
    widget = wibox.container.background,
  })

  if n.icon then
    app_icon_n = nil
  end

  local icon = wibox.widget({
    {
      {
        {
          {
            image = n.icon,
            resize = true,
            clip_shape = gears.shape.circle,
            halign = "center",
            valign = "center",
            widget = wibox.widget.imagebox,
          },
          margins = dpi(4),
          widget = wibox.container.margin,
        },
        bg = beautiful.palette.bg2,
        shape = gears.shape.circle,
        widget = wibox.container.background,
      },
      strategy = "exact",
      height = dpi(48),
      width = dpi(48),
      widget = wibox.container.constraint,
    },
    {
      app_icon_n,
      widget = wibox.container.place,
    },
    layout = wibox.layout.stack,
  })

  local _app_name = n.app_name ~= "notify-send" and n.app_name or "System Notification"
  local app_name = wibox.widget({
    {
      text = _app_name:gsub("^%l", string.upper),
      font = beautiful.font_family .. " Bold 11",
      widget = wibox.widget.textbox,
    },
    forced_width = dpi(200),
    strategy = "max",
    widget = wibox.container.constraint,
  })

  local dismiss = wibox.widget({
    {
      text = "",
      font = beautiful.icon_font .. " Round 14",
      align = "center",
      valign = "center",
      widget = wibox.widget.textbox,
    },
    fg = beautiful.notification_dismiss,
    buttons = {
      awful.button({}, 1, function()
        on_remove(i)
      end),
    },
    widget = wibox.container.background,
  })

  -- Change cursor on dismiss button hover
  lib.ui.add_hover_cursor(dismiss)

  local restore = wibox.widget({
    {
      text = "",
      font = beautiful.icon_font .. " Round 14",
      align = "center",
      valign = "center",
      widget = wibox.widget.textbox,
    },
    fg = beautiful.notification_restore,
    buttons = {
      awful.button({}, 1, function()
        naughty.notification({
          title = n.title,
          timeout = n.timeout,
          message = n.message,
          actions = n.actions,
          app_name = n.app_name,
          icon = n.icon,
          app_icon = n.app_icon,
        })
        on_remove(i)
      end),
    },
    widget = wibox.container.background,
  })

  -- Change cursor on dismiss button hover
  lib.ui.add_hover_cursor(restore)

  local title = wibox.widget({
    {
      text = n.title,
      font = beautiful.font_family .. " Bold 11",
      widget = wibox.widget.textbox,
    },
    step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
    fps = 60,
    speed = 75,
    widget = wibox.container.scroll.horizontal,
  })

  local message = wibox.widget({
    {
      {
        text = n.message,
        font = beautiful.font,
        widget = wibox.widget.textbox,
      },
      fg = beautiful.palette.fg3,
      widget = wibox.widget.background,
    },
    step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
    fps = 60,
    speed = 75,
    widget = wibox.container.scroll.horizontal,
  })

  local timestamp = wibox.widget({
    {
      {
        text = n.datetime,
        font = beautiful.font_family .. " Book 11",
        widget = wibox.widget.textbox,
      },
      widget = wibox.container.place,
    },
    fg = beautiful.palette.bg4,
    widget = wibox.widget.background,
  })

  local box = wibox.widget({
    {
      layout = wibox.layout.fixed.vertical,
      {
        {
          {
            app_name,
            timestamp,
            {
              restore,
              dismiss,
              spacing = dpi(4),
              layout = wibox.layout.fixed.horizontal,
            },
            layout = wibox.layout.align.horizontal,
          },
          margins = { top = dpi(5), bottom = dpi(5), left = dpi(15), right = dpi(15) },
          widget = wibox.container.margin,
        },
        bg = beautiful.notification_bg_alt,
        widget = wibox.container.background,
      },
      {
        {
          layout = wibox.layout.fixed.vertical,
          {
            icon,
            {
              nil,
              {
                title,
                message,
                spacing = dpi(4),
                layout = wibox.layout.fixed.vertical,
              },
              nil,
              expand = "none",
              layout = wibox.layout.align.vertical,
            },
            spacing = dpi(16),
            layout = wibox.layout.fixed.horizontal,
          },
          nil,
        },
        margins = dpi(10),
        widget = wibox.container.margin,
      },
    },
    --- Anti-aliasing container
    shape = lib.ui.rrect(beautiful.border_radius),
    bg = beautiful.notification_bg,
    border_width = dpi(1),
    border_color = beautiful.palette.bg3,
    widget = wibox.container.background,
  })

  return box
end

return _factory
