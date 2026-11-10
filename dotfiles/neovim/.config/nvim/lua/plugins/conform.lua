require("conform").setup({
	format_on_save = { lsp_format = "fallback", timeout_ms = 1000 },

	formatters = {
		djlint = { prepend_args = { "--indent", "2", "--max-line-length", "100" } },
		maudfmt = { args = { "-s" }, command = "maudfmt" },
	},

	formatters_by_ft = {
		sh = { "shfmt" },
		bash = { "shfmt" },

		elm = { "elm_format" },

		go = { "goimports", "golines", "gofmt", "gofumpt" },
		gomod = { "goimports", "golines", "gofmt", "gofumpt" },
		gotmpl = { "goimports", "golines", "gofmt", "gofumpt" },
		gowork = { "goimports", "golines", "gofmt", "gofumpt" },

		terraform = { "terraform_fmt", "tofu_fmt" },
		["terraform-vars"] = { "terraform_fmt", "tofu_fmt" },
		["hcl.terragrunt"] = { "terragrunt_hclfmt" },

		html = { "djlint" },
		htmldjango = { "djlint" },
		["jinja.html"] = { "djlint" },
		svelte = { "prettierd" },

		css = { "prettierd" },
		scss = { "prettierd" },

		javascript = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescript = { "prettierd" },
		typescriptreact = { "prettierd" },

		json = { "jq" },
		json5 = { "fixjson" },

		lua = { "stylua" },
		luau = { "stylua" },

		markdown = { "prettierd" },
		["markdown.mdx"] = { "prettierd" },

		nix = { "nixfmt" },

		plaintex = { "tex-fmt" },

		python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },

		rust = { "rustfmt", "maudfmt" },

		sql = { "sqruff" },

		tex = { "tex-fmt" },

		toml = { "taplo" },

		typst = { "typstyle" },

		yaml = { "yamlfmt" },
	},
})
