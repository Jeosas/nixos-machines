local function nonels()
	local null_ls = require("null-ls")

	local formatting = null_ls.builtins.formatting
	local diagnostics = null_ls.builtins.diagnostics

	null_ls.setup({
		debug = false,
		sources = {
			-- misc
			formatting.stylua, -- lua
			diagnostics.actionlint, -- github action
			diagnostics.zsh, -- zsh
			-- Python
			diagnostics.mypy,
			-- nix
			formatting.alejandra,
			diagnostics.statix,
		},
	})
end

nonels()
