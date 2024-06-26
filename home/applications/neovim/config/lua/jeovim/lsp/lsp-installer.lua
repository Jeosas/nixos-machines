local function lsp_config()
	local lspconfig = require("lspconfig")

	local default_opts = {
		on_attach = require("jeovim.lsp.handlers").on_attach,
		capabilities = require("jeovim.lsp.handlers").capabilities,
	}

	lspconfig["lua_ls"].setup({
		on_attach = require("jeovim.lsp.handlers").on_attach,
		capabilities = require("jeovim.lsp.handlers").capabilities,
		settings = {
			Lua = {
				version = { version = "max" },
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.stdpath("config") .. "/lua"] = true,
					},
				},
			},
		},
	})
	-- misc
	lspconfig["yamlls"].setup(default_opts)
	lspconfig["bashls"].setup(default_opts)
	lspconfig["marksman"].setup(default_opts) -- markdown
	lspconfig["texlab"].setup(default_opts) -- LaTeX
	lspconfig["jsonls"].setup(vim.tbl_deep_extend("force", require("jeovim.lsp.settings.jsonls"), default_opts))
	-- python
	lspconfig["pylsp"].setup(default_opts)
	-- rust
	lspconfig["rust_analyzer"].setup(default_opts)
	-- web
	lspconfig["html"].setup(default_opts)
	lspconfig["htmx"].setup(default_opts)
	lspconfig["svelte"].setup(default_opts)
	lspconfig["tsserver"].setup(default_opts)
	-- nix
	lspconfig["nil_ls"].setup(default_opts)
end

lsp_config()
