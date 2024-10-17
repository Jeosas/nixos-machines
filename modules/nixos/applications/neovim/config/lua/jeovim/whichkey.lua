local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	return
end

local setup = {
	plugins = {
		marks = true, -- shows a list of your marks on ' and `
		registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		spelling = {
			enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
			suggestions = 20, -- how many suggestions should be shown in the list?
		},
		-- the presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		presets = {
			operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = true, -- adds help for motions
			text_objects = true, -- help for text objects triggered after entering an operator
			windows = true, -- default bindings on <c-w>
			nav = true, -- misc bindings to work with windows
			z = true, -- bindings for folds, spelling and others prefixed with z
			g = true, -- bindings for prefixed with g
		},
	},
	-- add operators that will trigger motion and text object completion
	-- to enable all native operators, set the preset / operators plugin above
	-- operators = {
	-- 	gc = "Comment",
	-- },
	replace = {
		key = {
			{ "<space>", "SPC" },
			{ "<tab>", "TAB" },
			-- {"<cr>", "RET"},
		},
	},
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "➜", -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
	},
	keys = {
		scroll_down = "<c-d>", -- binding to scroll down inside the popup
		scroll_up = "<c-u>", -- binding to scroll up inside the popup
	},
	win = {
		border = "none", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 1, 0 }, -- extra window margin [top/bottom, left/right]
		padding = { 2, 2 }, -- extra window padding [top/bottom, left/right]
		wo = {
			winblend = 0,
		},
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "left", -- align columns left, center or right
	},
	filter = function(mapping)
		-- exclude mappings without a description
		return mapping.desc and mapping.desc ~= ""
	end,
	show_help = true, -- show help message on the command line when the popup is visible
	triggers = {
		{ "auto", mode = "nxso" },
	},
}

local mappings = {
	nowait = true,
	remap = false,
	{ "<leader><leader>", "<cmd>Telescope find_files<cr>", desc = "Find files" },

	{ "<leader>?", group = "Search" },
	{ "<leader>??", "<cmd>Telescope commands<cr>", desc = "Commands" },
	{ "<leader>?R", "<cmd>Telescope registers<cr>", desc = "Registers" },
	{ "<leader>?c", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme" },
	{ "<leader>?h", "<cmd>Telescope help_tags<cr>", desc = "Find Help" },
	{ "<leader>?k", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
	{ "<leader>?m", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },

	{ "<leader>b", group = "Buffer" },
	{
		"<leader>bb",
		"<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
		desc = "List open buffers",
	},

	{ "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "File explorer" },

	{ "<leader>f", group = "Files" },
	{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
	{ "<leader>fr", ":Telescope oldfiles <cr>", desc = "Recent files" },
	{ "<leader>fw", "<cmd>Telescope live_grep theme=ivy<cr>", desc = "Find word" },

	{ "<leader>g", group = "Git" },
	{
		"<leader>gR",
		"<cmd>lua require 'gitsigns'.reset_buffer()<cr>",
		desc = "Reset Buffer",
	},
	{ "<leader>gb", "<cmd>lua require 'gitsigns'.blame_line()<cr>", desc = "Blame" },
	{ "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Diff" },
	{ "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", desc = "Lazygit" },
	{ "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", desc = "Reset Hunk" },

	{ "<leader>h", "<cmd>nohlsearch<CR>", desc = "Reset highlight" },

	{ "<leader>l", group = "LSP" },
	{
		"<leader>lS",
		"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
		desc = "Workspace Symbols",
	},
	{ "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action" },
	{ "<leader>lf", "<cmd>lua vim.lsp.buf.format{async=true}<cr>", desc = "Format" },
	{ "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
	{
		"<leader>lj",
		"<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
		desc = "Next Diagnostic",
	},
	{
		"<leader>lk",
		"<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",
		desc = "Prev Diagnostic",
	},
	{ "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
	{
		"<leader>ls",
		"<cmd>Telescope lsp_document_symbols<cr>",
		desc = "Document Symbols",
	},

	{ "<leader>p", group = "Project" },
	{ "<leader>pT", "<cmd>lua _PROJECT_TEST_ALL()<cr>", desc = "Run all tests" },
	{ "<leader>pa", "<cmd>lua _PROJECT_DEP_ADD()<cr>", desc = "Add project dependency" },
	{ "<leader>pc", "<cmd>lua _PROJECT_CHECK()<cr>", desc = "Check project" },
	{
		"<leader>pi",
		"<cmd>lua _PROJECT_DEP_INSTALL()<cr>",
		desc = "Install project dependencies",
	},
	{ "<leader>pp", ":Telescope projects <cr>", desc = "Open project" },
	{ "<leader>pr", "<cmd>lua _PROJECT_RUN()<cr>", desc = "Run project" },
	{ "<leader>pt", "<cmd>lua _PROJECT_TEST_FUNCTION()<cr>", desc = "Run test" },

	{ "<leader>t", "<cmd>ToggleTerm direction=float<cr>", desc = "Open Terminal" },

	{ "K", desc = "Show documentation" },
}

which_key.setup(setup)
which_key.add(mappings)
