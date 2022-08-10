local utils = require("themegen.utils")

local _qutebrowser_template = {}

_qutebrowser_template.name = "qutebrowser"

_qutebrowser_template.path = "qutebrowser"
_qutebrowser_template.filename = "theme.py"

_qutebrowser_template.gen = function(schema)
	local template = utils.template(
		[[
# ${theme} colorscheme for QuteBrowser
# ~/.config/qutebrowser/theme.py

colors = {
    'accent': '${accent}',
    'bg0': '${bg0}',
    'bg1': '${bg1}',
    'bg2': '${bg2}',
    'bg3': '${bg3}',
    'bg4': '${bg4}',
    'fg0': '${fg0}',
    'fg1': '${fg1}',
    'fg2': '${fg2}',
    'fg3': '${fg3}',
    'black': '${black}',
    'red': '${red}',
    'orange': '${orange}',
    'yellow': '${yellow}',
    'green': '${green}',
    'teal': '${teal}',
    'cyan': '${cyan}',
    'blue': '${blue}',
    'magenta': '${magenta}',
    'purple': '${purple}',
    'white': '${white}',
    'gray': '${gray}',
}
    ]],
		schema
	)

	return template
end

return _qutebrowser_template
