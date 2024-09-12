local c = require("vscode.colors")
require("vscode").setup({
	-- Enable transparent background
	transparent = false,

	-- Enable italic comment
	italic_comments = true,

	-- Disable nvim-tree background color
	disable_nvimtree_bg = false,

	-- Override colors (see ./lua/vscode/colors.lua)
	color_overrides = {
		-- vscLineNumber = '#FFFFFF',
	},

	-- Override highlight groups (see ./lua/vscode/theme.lua)
	group_overrides = {
		-- Cursor = { fg=c.vscDarkBlue, bg=c.vscLightGreen, bold=true },
	},
})
