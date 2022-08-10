local utils = require("themegen.utils")

local _btop_template = {}

_btop_template.name = "btop"

_btop_template.path = "btop/themes"
_btop_template.filename = "theme.theme"

_btop_template.gen = function(schema)
	local template = utils.template(
		[[
# ${theme} colorscheme for btop
# ~/.config/btop/themes/theme.theme

# All graphs and meters can be gradients
# For single color graphs leave "mid" and "end" variable empty.
# Use "start" and "end" variables for two color gradient
# Use "start", "mid" and "end" for three color gradient

# Main background, empty for terminal default, need to be empty if you want transparent background
theme[main_bg]="${bg1}"

# Main text color
theme[main_fg]="${fg1}"

# Title color for boxes
theme[title]="${fg1}"

# Highlight color for keyboard shortcuts
theme[hi_fg]="${red}"

# Background color of selected items
theme[selected_bg]="${bg4}"

# Foreground color of selected items
theme[selected_fg]="${yellow}"

# Color of inactive/disabled text
theme[inactive_fg]="${fg3}"

# Color of text appearing on top of graphs, i.e uptime and current network graph scaling
theme[graph_text]="${fg1}"

# Misc colors for processes box including mini cpu graphs, details memory graph and details status text
theme[proc_misc]="${accent}"

# Cpu box outline color
theme[cpu_box]=${bg4}""

# Memory/disks box outline color
theme[mem_box]="${bg4}"

# Net up/down box outline color
theme[net_box]="${bg4}"

# Processes box outline color
theme[proc_box]="${bg4}"

# Box divider line and small boxes line color
theme[div_line]="${bg4}"

# Temperature graph colors
theme[temp_start]="${green}"
theme[temp_mid]="${yellow}"
theme[temp_end]="${red}"

# CPU graph colors
theme[cpu_start]="${green}"
theme[cpu_mid]="${yellow}"
theme[cpu_end]="${red}"

# Mem/Disk free meter
theme[free_start]="${green}"
theme[free_mid]="${yellow}"
theme[free_end]="${red}"

# Mem/Disk cached meter
theme[cached_start]="${green}"
theme[cached_mid]="${yellow}"
theme[cached_end]="${red}"

# Mem/Disk available meter
theme[available_start]="${green}"
theme[available_mid]="${yellow}"
theme[available_end]="${red}"

# Mem/Disk used meter
theme[used_start]="${green}"
theme[used_mid]="${yellow}"
theme[used_end]="${red}"

# Download graph colors
theme[download_start]="${green}"
theme[download_mid]="${yellow}"
theme[download_end]="${red}"

# Upload graph colors
theme[upload_start]="${green}"
theme[upload_mid]="${yellow}"
theme[upload_end]="${red}"

# Process box color gradient for threads, mem and cpu usage
theme[process_start]="${green}"
theme[process_mid]="${yellow}"
theme[process_end]="${red}"
    ]],
		schema
	)

	return template
end

return _btop_template
