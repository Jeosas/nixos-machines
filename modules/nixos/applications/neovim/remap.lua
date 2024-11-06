local function remap()
	-- helpers
	local opts = { noremap = true, silent = true }
	local keymap = vim.api.nvim_set_keymap

	--Remap space as leader key
	keymap("", "<Space>", "<Nop>", opts)
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "

	-- Modes
	--   normal_mode = "n",
	--   insert_mode = "i",
	--   visual_mode = "v",
	--   visual_block_mode = "x",
	--   term_mode = "t",
	--   command_mode = "c",

	-- Normal --
	-- Buffers
	keymap(
		"n",
		"<leader>bb",
		"<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
		opts
	)

	-- File explorer
	keymap("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", opts)

  -- Files
	keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
	keymap("n", "<leader><leader>", "<cmd>Telescope find_files<cr>", opts)
	keymap("n", "<leader>fr", "<cmd>Telescope oldfiles <cr>", opts)
	keymap("n", "<leader>fw", "<cmd>Telescope live_grep theme=ivy<cr>", opts)

  -- Git
	keymap("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<cr>", opts)
	keymap("n", "<leader>gb", "<cmd>lua require 'gitsigns'.blame_line()<cr>", opts)
	keymap("n", "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", opts)
	keymap("n", "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", opts)
  keymap("n", "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", opts)

  -- LSP
	keymap("n", "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", opts)
	keymap("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
	keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{async=true}<cr>", opts)
  keymap("n", "<leader>li", "<cmd>LspInfo<cr>", opts)
	keymap("n", "<leader>lj", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
	keymap("n", "<leader>lk", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", opts)
	keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
	keymap("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", opts)

  -- Terminal
	keymap("n", "<leader>t", "<cmd>ToggleTerm direction=float<cr>", opts)

	-- Disable Ex mode
	keymap("n", "Q", "<Nop>", opts)

	-- Better window navigation
	keymap("n", "<C-h>", "<C-w>h", opts)
	keymap("n", "<C-j>", "<C-w>j", opts)
	keymap("n", "<C-k>", "<C-w>k", opts)
	keymap("n", "<C-l>", "<C-w>l", opts)

	-- Navigate buffers
	keymap("n", "<A-l>", ":bnext<CR>", opts)
	keymap("n", "<A-h>", ":bprevious<CR>", opts)

	-- Move text up and down
	keymap("n", "<A-j>", "<Esc>:m .+1<CR>==", opts)
	keymap("n", "<A-k>", "<Esc>:m .-2<CR>==", opts)

	-- Buffer recentering
	keymap("n", "<C-u>", "<C-u>zz", opts)
	keymap("n", "<C-d>", "<C-d>zz", opts)
	keymap("n", "n", "nzzzv", opts)
	keymap("n", "N", "Nzzzv", opts)
	keymap("n", "*", "*zzzv", opts)
	keymap("n", "#", "#zzzv", opts)

	-- Insert --
	-- Press jk fast to exit insert mode
	keymap("i", "jk", "<ESC>", opts)
	keymap("i", "kj", "<ESC>", opts)

	-- Visual --
	-- Stay in indent mode
	keymap("v", "<", "<gv", opts)
	keymap("v", ">", ">gv", opts)

	-- Move text up and down
	keymap("v", "<A-j>", ":m .+1<CR>==", opts)
	keymap("v", "<A-k>", ":m .-2<CR>==", opts)

	-- Keep copied tet in register when replacing
	keymap("v", "p", '"_dP', opts)

	-- Visual Block --
	-- Move text up and down
	keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
	keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)
end

remap()
