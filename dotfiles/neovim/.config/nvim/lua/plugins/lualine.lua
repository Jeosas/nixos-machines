require("lualine").setup({
	inactive_sections = {
		lualine_c = {
			{ "filetype", colored = true, icon_only = true, padding = { left = 1, right = 0 } },
			{
				"filename",
				file_status = true,
				symbols = { modified = "", newfile = "[New]", readonly = "", unnamed = "[No Name]" },
			},
		},
		lualine_x = { { "location", padding = 1 } },
	},
	options = {
		always_divide_middle = true,
		component_separators = { left = "", right = "" },
		disabled_filetypes = { "alpha", "dashboard", "Outline" },
		globalstatus = true,
		icons_enabled = true,
		section_separators = { left = "", right = "" },
	},
	sections = {
		lualine_a = { { "mode", color = { gui = "bold" } } },
		lualine_b = {
			{ "filetype", colored = true, icon_only = true, padding = { left = 1, right = 0 } },
			{
				"filename",
				file_status = true,
				symbols = { modified = "", newfile = "[New]", readonly = "", unnamed = "[No Name]" },
			},
		},
		lualine_c = {
			{ "branch", icon = "", icons_enabled = true },
			{ "diff", colored = false, symbols = { added = " ", modified = " ", removed = " " } },
		},
		lualine_x = {
			{
				"diagnostics",
				sections = { "error", "warn" },
				sources = { "nvim_diagnostic" },
				symbols = { error = " ", warn = " " },
			},
		},
		lualine_z = { { "location", padding = 1 } },
	},
})
