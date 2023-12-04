--check install
-- local result_ok, _, _ = os.execute("command -v lua-language-server &> /dev/null")
-- if not result_ok then
-- 	vim.notify(
-- 		"Couldn't install 'lua' lsp.\nPlease install the folowing packages:\n - lua-language-server (lsp)\n - stylua (fmt)",
-- 		"error"
-- 	)
-- end

-- lsp settings
return {
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
}
