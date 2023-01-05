local gfs = require("gears.filesystem")

local config_dir = gfs.get_configuration_dir()
local launcher_theme = config_dir .. "externals/rofi/launcher.rasi"
local windows_list_theme = config_dir .. "externals/rofi/windows.rasi"

return {
  --- Default Applications
  default = {
    -- Default terminal emulator
    terminal = "alacritty",
    -- Floating term
    float_term = "alacritty --class float-term",
    -- Default code editor
    editor = "nvim",
    -- Calculator
    calculator = "alacritty --class calc -e calc",
    -- Default web browser
    browser = "firefox-developer-edition",
    -- Default dev browser
    dev_browser = "chromium",
    -- Default file manager
    file_manager = "thunar",
    -- Default network manager
    network_manager = "alacritty --class nmtui -e nmtui",
    -- Default volume control wibar
    volume_control = "pavucontrol",
    -- Default system monitor
    system_monitor = "alacritty --class btop -e btop",
    -- Default applications launcher
    launcher = "rofi -no-lazy-grab -show drun -modi drun -theme " .. launcher_theme,
  },
  --- Utilities
  utils = {
    -- List windows
    colorpicker = config_dir .. "scripts/colorpicker",
    documents = config_dir .. "scripts/documents",
    nightlight = config_dir .. "scripts/nightlight toggle",
    screenshot = config_dir .. "scripts/screenshot",
    screenshot_screen = config_dir .. "scripts/screenshot screen",
    screenshot_window = config_dir .. "scripts/screenshot window",
    screenshot_crop = config_dir .. "scripts/screenshot crop",
    screencast = config_dir .. "scripts/screencast",
    windows_list = "rofi -no-lazy-grab -show window -modi window -theme " .. windows_list_theme,
    powermenu = config_dir .. "scripts/powermenu",
    network = config_dir .. "scripts/network",
    bluetooth = config_dir .. "scripts/bluetooth",
    sound = config_dir .. "scripts/sound",
  },
}
