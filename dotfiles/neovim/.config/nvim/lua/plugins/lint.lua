local lint = require("lint")

lint.linters_by_ft = {
	bash = { "bash", "shellcheck" },
	go = { "golangcilint" },
	gomod = { "golangcilint" },
	gotmpl = { "golangcilint" },
	gowork = { "golangcilint" },
	html = { "djlint" },
	htmldjango = { "djlint" },
	javascript = { "eslint_d" },
	javascriptreact = { "eslint_d" },
	["jinja.html"] = { "djlint" },
	json = { "json_tool" },
	lua = { "luac" },
	luau = { "luac" },
	nix = { "statix" },
	python = { "ruff", "mypy" },
	sh = { "bash", "shellcheck" },
	sql = { "sqruff" },
	terraform = { "tflint", "trivy" },
	["terraform-vars"] = { "tflint", "trivy" },
	typescript = { "eslint_d" },
	typescriptreact = { "eslint_d" },
	yaml = { "yamllint" },
	["yaml.ghaction"] = { "actionlint" },
	zsh = { "zsh", "shellcheck" },
}

vim.api.nvim_create_autocmd("BufWritePost", {
	callback = function()
		require("lint").try_lint()
	end,
})
