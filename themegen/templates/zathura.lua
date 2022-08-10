local utils = require("themegen.utils")

local _zathura_template = {}

_zathura_template.name = "zathura"

_zathura_template.path = "zathura"
_zathura_template.filename = "theme"

_zathura_template.gen = function(schema)
	local template = utils.template(
		[[
set default-fg "${fg1}"
set default-bg "${bg1}"

set completion-bg "${bg1}"
set completion-fg "${fg1}"
set completion-highlight-bg "${bg4}"
set completion-highlight-fg "${fg1}"
set completion-group-bg "${bg1}"
set completion-group-fg "${accent}"

set statusbar-fg "${fg1}"
set statusbar-bg "${bg1}"

set notification-bg "${bg1}"
set notification-fg "${fg1}"
set notification-error-bg "${bg1}"
set notification-error-fg "${red}"
set notification-warning-bg "${bg1}"
set notification-warning-fg "${yellow}"

set inputbar-fg "${fg1}"
set inputbar-bg "${bg1}"

set recolor-lightcolor "${bg1}"
set recolor-darkcolor "${fg1}"

set index-fg "${fg1}"
set index-bg "${bg2}"
set index-active-fg "${fg1}"
set index-active-bg "${bg1}"

set render-loading-bg "${bg1}"
set render-loading-fg "${fg1}"

set highlight-color "${bg4}"
set highlight-fg "${accent}"
set highlight-active-color "${accent}"
    ]],
		schema
	)

	return template
end

return _zathura_template
