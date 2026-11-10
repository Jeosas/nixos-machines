require("gitsigns").setup({ attach_to_untracked = true })

-- set key binding
vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns blame<cr>", { desc = "Git blame" })
vim.keymap.set("n", "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", { desc = "Git diff" })
vim.keymap.set("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Git reset hunk" })
vim.keymap.set("n", "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>", { desc = "Git reset buffer" })
vim.keymap.set("n", "<leader>gj", "<cmd>Gitsigns toggle_deleted<cr>", { desc = "Git toggle deleted" })

-- set special blame keymap
vim.api.nvim_create_autocmd("FileType", {
	desc = "Easy quit git blame with q",
	pattern = "gitsigns-blame",
	command = "nnoremap <silent> <buffer> q :bd<CR>",
})
