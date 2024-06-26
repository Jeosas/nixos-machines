vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
	end,
})

require("lint").linters_by_ft = {
	yaml = { "actionlint" },
	nix = { "statix" },
	python = { "mypy" },
	zsh = { "zsh" },
}
