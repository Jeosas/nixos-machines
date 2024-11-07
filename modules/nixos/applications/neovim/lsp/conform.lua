require("conform").setup({
	format_on_save = {
		timeout_ms = 1000,
		lsp_format = "fallback",
	},
	formatters_by_ft = {
		lua = { "stylua" },
		luau = { "stylua" },
		nix = { "alejandra" },
		javascript = { { "prettierd", "prettier" } },
		typescript = { { "prettierd", "prettier" } },
		javascriptreact = { { "prettierd", "prettier" } },
		typescriptreact = { { "prettierd", "prettier" } },
		svelte = { { "prettierd", "prettier" } },
		css = { { "prettierd", "prettier" } },
		scss = { { "prettierd", "prettier" } },
		html = { { "prettierd", "prettier" } },
		htmldjango = { "djlint" },
		json = { { "prettierd", "prettier" } },
		yaml = { { "prettierd", "prettier" } },
		markdown = { { "prettierd", "prettier" } },
		python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
	},
	formatters = {
		djlint = {
			prepend_args = { "--indent", "2", "--max-line-length", "100" },
		},
	},
})
