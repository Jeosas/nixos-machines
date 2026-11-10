-- =============================================================================
-- Core Keymaps
-- Base keymaps from init.lua and lua/enhancement/config/keymaps.lua
-- =============================================================================

local map = vim.keymap.set

-- =============================================================================
-- BASIC
-- =============================================================================

-- Disable Ex mode
map("n", "Q", "<Nop>")

-- Clear highlights on search when pressing <Esc> in normal mode
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Lsp keymaps
map("n", "<leader>le", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
map("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Open lsp code actions" })

-- Exit terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- =============================================================================
-- NAVIGATION & WINDOW MANAGEMENT
-- =============================================================================

map("n", "<C-h>", "<C-w>h", { desc = "Focus window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Focus window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Focus window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Focus window right" })

-- =============================================================================
-- BUFFER NAVIGATION
-- =============================================================================

-- Previous/next buffer
map("n", "<A-h>", "<cmd>bprev<cr>", { desc = "Previous buffer" })
map("n", "<A-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- =============================================================================
-- TEXT EDITING ENHANCEMENTS
-- =============================================================================

-- Better indenting in visual mode
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Move text up and down
map({ "n", "v", "x" }, "<A-j>", "<Esc>:m .+1<CR>==", { desc = "Move selection down" })
map({ "n", "v", "x" }, "<A-k>", "<Esc>:m .-2<CR>==", { desc = "Move selection up" })

-- Better paste in visual mode
map({ "v", "x" }, "p", '"_dP', { desc = "Paste without overwriting clipboard" })

-- Join lines without moving cursor
map("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })

-- Center screen when navigating
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "n", "nzzzv", { desc = "Next search result and center" })
map("n", "N", "Nzzzv", { desc = "Previous search result and center" })
map("n", "*", "*zzzv", { desc = "Next identical word and center" })
map("n", "#", "#zzzv", { desc = "Previous identical word and center" })

-- =============================================================================
-- QUICK ACTIONS
-- =============================================================================

-- Toggle line wrapping
map("n", "<leader>uw", "<cmd>set wrap!<cr>", { desc = "Toggle line wrap" })

-- Toggle spell checking
map("n", "<leader>us", "<cmd>set spell!<cr>", { desc = "Toggle [S]pell check" })
