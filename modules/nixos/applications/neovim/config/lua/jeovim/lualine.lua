local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

local hide_in_width = function()
	return vim.fn.winwidth(0) > 80
end

local mode = {
	"mode",
	color = { gui = "bold" },
}

local file_type = {
	"filetype",
	icon_only = true,
	colored = true,
	padding = { left = 1, right = 0 },
}

local file_name = {
	"filename",
	file_status = true,
	symbols = {
		modified = "",
		readonly = "",
		unnamed = "[No Name]",
		newfile = "[New]",
	},
}

local git_branch = {
	"branch",
	icons_enabled = true,
	icon = "",
}

local git_diff = {
	"diff",
	colored = false,
	symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
	cond = hide_in_width,
}

local spaces = function()
	return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

local file_encoding = { "encoding" }

local lsp_diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = { error = " ", warn = " " },
}

local cur_position = {
	"location",
	padding = 1,
}

lualine.setup({
	options = {
		icons_enabled = true,
		theme = "nord",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "alpha", "dashboard", "Outline" },
		always_divide_middle = true,
		globalstatus = true,
	},
	sections = {
		lualine_a = { mode },
		lualine_b = { file_type, file_name },
		lualine_c = { git_branch, git_diff },
		lualine_x = { spaces, file_encoding },
		lualine_y = { lsp_diagnostics },
		lualine_z = { cur_position },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { file_type, file_name },
		lualine_x = { cur_position },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = {},
})
