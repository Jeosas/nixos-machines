local function nonels()
	local null_ls = require("null-ls")

	local formatting = null_ls.builtins.formatting
	local diagnostics = null_ls.builtins.diagnostics

	null_ls.setup({
		debug = false,
		sources = {
			-- Lua
			formatting.stylua,
			-- Python
			diagnostics.mypy,
			diagnostics.actionlint,
			-- zsh
			diagnostics.zsh,
		},
	})
end

nonels()
