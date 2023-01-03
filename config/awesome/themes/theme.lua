local gears = require("gears")
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gfs = gears.filesystem
local config_dir = gfs.get_configuration_dir()

local palette = require("themes.palette")

local theme = {}

-- Sizes
theme.master_width_factor = 0.60

-- Fonts
theme.font_family = "Jetka"
theme.font = theme.font_family .. " Semibold 11"
theme.icon_font = "Material Icons"

-- Palette
theme.palette = palette
theme.palette.transparent = "#00000000"

-- Xresources
theme.xcolor0 = theme.palette.black
theme.xcolor8 = theme.palette.black
theme.xcolor1 = theme.palette.red
theme.xcolor9 = theme.palette.red
theme.xcolor2 = theme.palette.green
theme.xcolor10 = theme.palette.green
theme.xcolor3 = theme.palette.orange
theme.xcolor11 = theme.palette.orange
theme.xcolor4 = theme.palette.blue
theme.xcolor12 = theme.palette.blue
theme.xcolor5 = theme.palette.magenta
theme.xcolor13 = theme.palette.magenta
theme.xcolor6 = theme.palette.cyan
theme.xcolor14 = theme.palette.cyan
theme.xcolor7 = theme.palette.white
theme.xcolor15 = theme.palette.white

-- Backgrounds & Foregrounds
theme.bg_normal = theme.palette.bg1
theme.bg_focus = theme.palette.accent
theme.bg_urgent = theme.palette.red
theme.bg_minimize = theme.palette.yellow
theme.bg_systray = theme.bg_normal

theme.fg_normal = theme.palette.fg1
theme.fg_focus = theme.palette.fg0
theme.fg_urgent = theme.palette.red
theme.fg_minimize = theme.palette.yellow

-- Gaps & Borders
theme.useless_gap = dpi(2)
theme.border_width = dpi(1)
theme.border_color_normal = theme.palette.black
theme.border_color_active = theme.palette.accent
theme.border_color_marked = theme.palette.orange

-- Icon Theme
theme.icon_theme = "Papirus-Dark"

-- Wibar
theme.wibar_height = dpi(36)
theme.wibar_border_width = dpi(0)
theme.wibar_border = theme.palette.bg1
theme.wibar_bg = theme.palette.bg0
theme.wibar_fg = theme.palette.bg1

-- Popup
theme.popup_bg = theme.palette.bg0

-- Wallpapers
theme.wallpaper = gears.surface.load_uncached(config_dir .. "themes/wallpapers/wallpaper.jpg")
theme.lockscreen = gears.surface.load_uncached(config_dir .. "themes/wallpapers/lockscreen.jpg")

-- Images
theme.avatar = gears.surface.load_uncached(config_dir .. "themes/images/avatar.png")

-- Radius
theme.border_radius = dpi(4)

-- Tooltip
theme.tooltip_bg = theme.palette.bg0
theme.tooltip_fg = theme.palette.fg1
theme.tooltip_font = theme.font
theme.tooltip_border_width = dpi(1)
theme.tooltip_border_color = theme.palette.bg4
theme.tooltip_opacity = 1

-- Tag list
local taglist_square_size = dpi(0)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

-- Notifications
theme.notification_spacing = dpi(4)
theme.notification_bg = theme.palette.bg0
theme.notification_bg_alt = theme.palette.bg1
theme.notification_critical_bg = theme.palette.accent
theme.notification_critical_fg = theme.palette.fg1
theme.notification_dismiss = theme.palette.red
theme.notification_restore = theme.palette.accent
theme.notification_font = theme.font

-- Layout Icons
theme.layout_tile = config_dir .. "assets/layouts/tile.png"
theme.layout_floating = config_dir .. "assets/layouts/floating.png"
theme.layout_dwindle = config_dir .. "assets/layouts/dwindle.png"
theme.layout_max = config_dir .. "assets/layouts/max.png"

-- Text Icons
theme.icon_dashboard = ""
theme.icon_power = ""
theme.icon_cpu = ""
theme.icon_memory = ""
theme.icon_disk = ""
theme.icon_temp = ""
theme.icon_volume = ""
theme.icon_volume_mute = ""
theme.icon_network = ""
theme.icon_network_disabled = ""
theme.icon_notifications = ""
theme.icon_notifications_active = ""
theme.icon_notifications_dnd = ""
theme.icon_notifications_dnd_none = ""
theme.icon_nightlight = ""
theme.icon_nightlight_disabled = ""
theme.icon_systray_closed = ""
theme.icon_systray_opened = ""
theme.icon_sysguard = ""
theme.icon_sysguard_warning = ""
theme.icon_airplane = ""
theme.icon_airplane_off = ""
theme.icon_bluetooth = ""
theme.icon_bluetooth_off = ""
theme.icon_microphone = ""
theme.icon_microphone_off = ""
theme.icon_screenshot = ""
theme.icon_recorder = ""
theme.icon_music_player_play = ""
theme.icon_music_player_pause = ""
theme.icon_music_player_stop = ""
theme.icon_music_player_next = ""
theme.icon_music_player_prev = ""
theme.icon_music_player_repeat = ""
theme.icon_music_player_repeat_one = ""
theme.icon_music_player_shuffle = ""

return theme
