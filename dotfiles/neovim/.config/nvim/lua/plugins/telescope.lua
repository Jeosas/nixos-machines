local telescope = require("telescope").setup({
	defaults = {
		prompt_prefix = " ",
		selection_caret = " ",
		path_display = { "smart" },
	},

	extensions = {
		undo = {
			mappings = {
				i = {
					["<cr>"] = require("telescope-undo.actions").restore,
					["<C-cr>"] = require("telescope-undo.actions").yank_additions,
				},
			},
		},
	},
})

require("telescope").load_extension("undo")

-- set key binding
vim.keymap.set("n", "<leader><leader>", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })
vim.keymap.set("n", "<leader>fw", "<cmd>Telescope live_grep theme=ivy<cr>", { desc = "Find words" })

vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<cr>", { desc = "Buffer list" })
vim.keymap.set("n", "<leader>?", "<cmd>Telescope keymaps<cr>", { desc = "Keybindings" })
vim.keymap.set("n", "<leader>.", "<cmd>Telescope help_tags<cr>", { desc = "Neovim help" })

vim.keymap.set("n", "<leader>uS", "<cmd>Telescope spell_suggest<cr>", { desc = "Spelling suggestions" })
vim.keymap.set("n", "<leader>uu", "<cmd>Telescope undo<cr>", { desc = "Undo tree" })

vim.keymap.set("n", "<leader>gd", "<cmd>Telescope lsp_definitions<cr>", { desc = "Go to definition" })
vim.keymap.set("n", "<leader>gD", "<cmd>Telescope lsp_references<cr>", { desc = "Go to references" })
vim.keymap.set("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Lsp document symbols" })
vim.keymap.set("n", "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "Lsp workspace symbols" })
