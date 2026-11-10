-- Install plugins but DO NOT add to runtimepath. The pack engine will call
-- :packadd <name> right before loading each plugin's module, keeping startup
-- to only catppuccin sourced on the first frame.
vim.pack.add({

	-- UI / Colorscheme
	{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/nanozuki/tabby.nvim",

	-- Core utilities
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/folke/snacks.nvim",

	-- Editor helpers
	-- 'https://github.com/folke/todo-comments.nvim',
	"https://github.com/lukas-reineke/indent-blankline.nvim",

	-- Completion (blink.cmp v2 tracks main; the lock pins the exact rev)
	"https://github.com/saghen/blink.lib",
	{ src = "https://github.com/saghen/blink.cmp", version = "main" },

	-- Formatting
	"https://github.com/stevearc/conform.nvim",

	-- Treesitter
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },

	-- Git
	"https://github.com/lewis6991/gitsigns.nvim",

	-- Editing enhancements
	"https://github.com/windwp/nvim-autopairs",

	-- Lsp helpers
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/jmbuhr/otter.nvim",
	"https://github.com/mfussenegger/nvim-lint",
	"https://github.com/b0o/SchemaStore.nvim",

	-- Language-specific
	"https://github.com/lukas-reineke/headlines.nvim",
	"https://github.com/chomosuke/typst-preview.nvim",
}, { confirm = false, load = function() end })

-- =============================================================================
-- Declarative loading registry
-- Each entry describes when and how to load a plugin module.
-- Fields:
--   mod     — module name under plugins/ (e.g. 'catppuccin' → plugins/catppuccin.lua)
--   event   — autocmd event (string or array) to trigger loading (once=true by default)
--   keys    — keymaps that trigger loading on first press; engine replays the key after
--   defer   — milliseconds to delay via vim.defer_fn
--   packadd — plugin directory names to :packadd before requiring the module
-- =============================================================================

local pack = require("core.pack")

pack.setup({

	-- -------------------------------------------------------------------------
	-- Immediate (first frame — keep minimal; only catppuccin)
	-- -------------------------------------------------------------------------
	{ mod = "catppuccin", packadd = { "catppuccin" } },

	-- -------------------------------------------------------------------------
	-- VimEnter (non-blocking — loads after init but before UI renders)
	-- Snacks setup (picker/explorer/image) + native bigfile/lazygit/terminal keymaps
	-- -------------------------------------------------------------------------
	{ mod = "auto_root", event = "VimEnter" },

	-- -------------------------------------------------------------------------
	-- UIEnter (non-blocking — loads after first frame renders)
	-- -------------------------------------------------------------------------
	{ mod = "lualine", event = "UIEnter", packadd = { "lualine.nvim", "nvim-web-devicons" } },
	{ mod = "tabby", event = "UIEnter", packadd = { "tabby.nvim", "nvim-web-devicons" } },
	{ mod = "snacks", event = "UIEnter", packadd = { "snacks.nvim", "nvim-web-devicons" } },

	-- -------------------------------------------------------------------------
	-- BufReadPre / BufNewFile (core file-level features)
	-- -------------------------------------------------------------------------
	{ mod = "indent_blank_line", event = { "BufReadPre", "BufNewFile" }, packadd = { "indent-blankline.nvim" } },
	{ mod = "treesitter", fn = "base", event = { "BufReadPre", "BufNewFile" }, packadd = { "nvim-treesitter" } },
	{
		mod = "lsp",
		event = { "BufReadPre", "BufNewFile" },
		packadd = { "nvim-lspconfig", "SchemaStore.nvim", "cmp-nvim-lsp" },
	},
	{ mod = "lint", event = { "BufReadPre", "BufNewFile" }, packadd = { "nvim-lint" } },
	{ mod = "otter", event = { "BufReadPre", "BufNewFile" }, packadd = { "otter.nvim" } },
	{ mod = "gitsigns", event = { "BufReadPre", "BufNewFile" }, packadd = { "gitsigns.nvim", "plenary.nvim" } },

	{
		mod = "typst_preview",
		event = { "BufReadPre", "BufNewFile" },
		pattern = "*.typ",
		packadd = { "typst-preview.nvim" },
	},

	-- -------------------------------------------------------------------------
	-- InsertEnter / CmdlineEnter (completion)
	-- -------------------------------------------------------------------------
	{ mod = "autopairs", event = { "InsertEnter", "CmdlineEnter" }, packadd = { "nvim-autopairs" } },
	{ mod = "indent_blank_line", event = { "BufReadPre", "BufNewFile" }, packadd = { "indent-blankline.nvim" } },
	{
		mod = "blink_cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		packadd = { "blink.lib", "blink.cmp" },
	},

	-- -------------------------------------------------------------------------
	-- BufWritePre (formatting on save — conform has its own internal guard)
	-- -------------------------------------------------------------------------
	{ mod = "conform", event = "BufWritePre", packadd = { "conform.nvim" } },

	-- -------------------------------------------------------------------------
	-- Keymap-triggered (first keypress loads the module, then replays the key)
	-- -------------------------------------------------------------------------

	-- { mod = 'tools', fn = 'productivity', keys = {
	--     { '<leader>uu',   desc = 'Undotree Toggle' },
	--   }, packadd = { 'nvim.undotree' } },

	-- -------------------------------------------------------------------------
	-- Deferred (idle — load after defer ms)
	-- -------------------------------------------------------------------------
	{ mod = "headlines", defer = 1, packadd = { "headlines.nvim" } },
})
