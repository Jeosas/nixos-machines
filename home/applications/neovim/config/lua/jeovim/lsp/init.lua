-- lsp install hints
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

require("jeovim.lsp.handlers").setup()
require("jeovim.lsp.lsp-installer")
