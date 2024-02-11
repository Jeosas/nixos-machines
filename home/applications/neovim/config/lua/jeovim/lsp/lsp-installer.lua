-- Available language servers
-- Server settings should be in a file located in `jeovim.lsp.settings.{server-name}.lua`
-- Server will be automatically installed.
-- Comment server if you do not wish to use them.
-- TODO make a command to manage lsps (activate + install / deactivate + uninstall)
local servers = {
	-- lua
	"lua_ls",
	-- json
	"jsonls",
	-- yaml
	"yamlls",
	-- bash
	"bashls",
	-- python
	"pylsp",
	-- rust
	"rust_analyzer",
	-- markdown
	"marksman",
	-- svelte
	"svelte",
	-- html
	"html",
	-- htmx
	"htmx",
	-- typescript
	"tsserver",
	-- nix
	"rnix",
}

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

local opts = {}

for _, server in pairs(servers) do
	opts = {
		on_attach = require("jeovim.lsp.handlers").on_attach,
		capabilities = require("jeovim.lsp.handlers").capabilities,
	}

	server = vim.split(server, "@")[1]

	local require_ok, conf_opts = pcall(require, "jeovim.lsp.settings." .. server)
	if require_ok then
		opts = vim.tbl_deep_extend("force", conf_opts, opts)
	end

	lspconfig[server].setup(opts)
end
