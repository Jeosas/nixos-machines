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
	key_labels = {
		-- override the label used to display some keys. It doesn't effect WK in any other way.
		-- For example:
		["<space>"] = "SPC",
		-- ["<cr>"] = "RET",
		["<tab>"] = "TAB",
	},
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "➜", -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
	},
	popup_mappings = {
		scroll_down = "<c-d>", -- binding to scroll down inside the popup
		scroll_up = "<c-u>", -- binding to scroll up inside the popup
	},
	window = {
		border = "none", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		winblend = 0,
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "left", -- align columns left, center or right
	},
	ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
	show_help = true, -- show help message on the command line when the popup is visible
	triggers = "auto", -- automatically setup triggers
	-- triggers = {"<leader>"} -- or specify a list manually
	triggers_blacklist = {
		-- list of mode / prefixes that should never be hooked by WhichKey
		-- this is mostly relevant for key maps that start with a native binding
		-- most people should not need to change this
		i = { "j", "k" },
		v = { "j", "k" },
	},
}

local opts = {
	mode = "n", -- NORMAL mode
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {

	K = { "Show documentation" },

	["<leader>"] = {
		["<leader>"] = { "<cmd>Telescope find_files<cr>", "Find files" },
		a = { "<cmd>Alpha<cr>", "Alpha" },
		e = { "<cmd>NvimTreeToggle<cr>", "File explorer" },
		q = { "<cmd>q<CR>", "Quit" },
		Q = { "<cmd>qa<CR>", "Quit all" },
		c = { "<cmd>Bdelete<CR>", "Close buffer" },
		h = { "<cmd>nohlsearch<CR>", "Reset highlight" },

		["?"] = {
			name = "Search",
			["?"] = { "<cmd>Telescope commands<cr>", "Commands" },
			c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
			k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
			h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
			m = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
			R = { "<cmd>Telescope registers<cr>", "Registers" },
		},

		b = {
			name = "Buffer",
			b = {
				"<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
				"List open buffers",
			},
			c = { "<cmd>Bdelete<CR>", "Close" },
			s = { "<cmd>w!<CR>", "Save" },
			S = { "<cmd>wa<CR>", "Save All" },
		},

		f = {
			name = "Files",
			f = { "<cmd>Telescope find_files<cr>", "Find files" },
			r = { ":Telescope oldfiles <cr>", "Recent files" },
			w = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find word" },
		},

		g = {
			name = "Git",
			d = { "<cmd>Gitsigns diffthis HEAD<cr>", "Diff" },
			g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
			b = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
			r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
			R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
		},

		l = {
			name = "LSP",
			a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
			d = {
				"<cmd>Telescope lsp_document_diagnostics<cr>",
				"Document Diagnostics",
			},
			f = { "<cmd>lua vim.lsp.buf.format{async=true}<cr>", "Format" },
			i = { "<cmd>LspInfo<cr>", "Info" },
			j = {
				"<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
				"Next Diagnostic",
			},
			k = {
				"<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",
				"Prev Diagnostic",
			},
			r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
			s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
			S = {
				"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
				"Workspace Symbols",
			},
			w = {
				"<cmd>Telescope lsp_workspace_diagnostics<cr>",
				"Workspace Diagnostics",
			},
		},

		p = {
			name = "Project",
			a = { "<cmd>lua _PROJECT_DEP_ADD()<cr>", "Add project dependency" },
			c = { "<cmd>lua _PROJECT_CHECK()<cr>", "Check project" },
			i = { "<cmd>lua _PROJECT_DEP_INSTALL()<cr>", "Install project dependencies" },
			p = { ":Telescope projects <cr>", "Open project" },
			r = { "<cmd>lua _PROJECT_RUN()<cr>", "Run project" },
			t = { "<cmd>lua _PROJECT_TEST_FUNCTION()<cr>", "Run test" },
			T = { "<cmd>lua _PROJECT_TEST_ALL()<cr>", "Run all tests" },
		},

		P = {
			name = "Packer",
			c = { "<cmd>PackerCompile<cr>", "Compile" },
			i = { "<cmd>PackerInstall<cr>", "Install" },
			s = { "<cmd>PackerSync<cr>", "Sync" },
			S = { "<cmd>PackerStatus<cr>", "Status" },
			u = { "<cmd>PackerUpdate<cr>", "Update" },
		},

		t = {
			name = "Tabs",
			a = { ":$tabnew<cr>", "Open new tab" },
			c = { ":tabclose<cr>", "Close current tab" },
			n = { ":tabn<cr>", "Go to next tab" },
			o = { ":tabonly<cr>", "Close all other tabs" },
			t = { ":tabn<cr>", "Go to next tab" },
			p = { ":tabp<cr>", "Go to previous tab" },
		},

		o = {
			name = "Open",
			-- p = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python console" },
			t = { "<cmd>ToggleTerm direction=float<cr>", "Terminal" },
		},

		w = {
			name = "Window",
			c = { "<C-w><C-q>", "Close" },
			h = { "<C-w><C-h>", "Go to the left window" },
			j = { "<C-w><C-j>", "Go to the down window" },
			k = { "<C-w><C-k>", "Go to the up window" },
			l = { "<C-w><C-l>", "Go to the right window" },
			q = { "<C-w><C-q>", "Close" },
			s = { "<C-w><C-s>", "Split horizontal" },
			v = { "<C-w><C-v>", "Split vertical" },
		},
	},

	g = {
		d = { "Go to definition" },
		l = { "Show diagnostic" },
	},
}

which_key.setup(setup)
which_key.register(mappings, opts)
