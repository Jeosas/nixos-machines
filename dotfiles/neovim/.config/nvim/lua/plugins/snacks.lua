local snacks = require("snacks")

snacks.setup({
	explorer = { replace_netrw = true, trash = false },
	notifier = {},
	picker = {
		ui_select = true,
		sources = {
			files = { hidden = true, ignored = false, follow = true },
			grep = { hidden = true, ignored = false, follow = true },
			keymaps = { global = true, ["local"] = true },
			explorer = {
				cwd = vim.uv.cwd(),
				layout = { preset = "sidebar", layout = { width = 0.15, min_width = 30 } },
				hidden = true,
				ignored = true,
				follow_file = true,
				git_status = true,
				git_untracked = true,
				diagnostics = true,
				auto_close = true,
				include = { ".gitattributes", ".gitignored", ".github", ".ci", ".opencode", ".agents" },
				exclude = {
					"*/node_modules",
					"*/__pycache__",
					"*/.pytest_cache",
					"*/.mypy_cache",
					"*/.ruff_cache",
					"*/.venv",
					"*/venv",
					"*/.svn",
					"*/spell",
					"*/venv.bak",
					"*/.Python",
					"*/src/*/tsconfig.json",
					"*/.DS_Store",
					"*/thumbs.db",
					"*.tmp",
					"*.temp",
					"*.pyc",
					"*.pyo",
					"*.pyd",
				},
			},
		},
	},
})

-- set key bindings
vim.keymap.set("n", "<leader>e", function()
	snacks.explorer()
end, { desc = "Toggle file explorer" })

vim.keymap.set("n", "<leader><leader>", function()
	snacks.picker.files()
end, { desc = "Find files" })
vim.keymap.set("n", "<leader>ff", function()
	snacks.picker.files()
end, { desc = "Find files" })
vim.keymap.set("n", "<leader>fr", function()
	snacks.picker.recent()
end, { desc = "Recent files" })
vim.keymap.set("n", "<leader>fw", function()
	snacks.picker.grep()
end, { desc = "Find words" })

vim.keymap.set("n", "<leader>b", function()
	snacks.picker.buffers()
end, { desc = "Buffer list" })
vim.keymap.set("n", "<leader>?", function()
	snacks.picker.keymaps()
end, { desc = "Keybindings" })
vim.keymap.set("n", "<leader>.", function()
	snacks.picker.help()
end, { desc = "Neovim help" })

vim.keymap.set("n", "<leader>uS", function()
	snacks.picker.spelling()
end, { desc = "Spelling suggestions" })
vim.keymap.set("n", "<leader>uu", function()
	snacks.picker.undo()
end, { desc = "Undo tree" })
-- vim.keymap.set("n", "<leader>ut", function()
-- 	snacks.picker.todo_comments()
-- end, { desc = "TODOs" })

vim.keymap.set("n", "<leader>n", function()
	snacks.notifier.show_history()
end, { desc = "Notification history" })

vim.api.nvim_create_autocmd("LspProgress", {
	---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
	callback = function(ev)
		local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
		vim.notify(vim.lsp.status(), "info", {
			id = "lsp_progress",
			title = "LSP Progress",
			opts = function(notif)
				notif.icon = ev.data.params.value.kind == "end" and " "
					or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
			end,
		})
	end,
})
