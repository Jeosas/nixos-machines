local M = {}

function M.base()
	require("nvim-treesitter").setup({ highlight = { enable = true }, indent = { enable = true } })

	-- auto-install parsers (deferred 500ms to not block startup)
	vim.defer_fn(function()
		local ensure_installed = require("nvim-treesitter").get_available() -- install all
		local installed = require("nvim-treesitter").get_installed()

		local missing = {}
		for _, lang in ipairs(ensure_installed) do
			if not vim.list_contains(installed, lang) then
				table.insert(missing, lang)
			end
		end

		if #missing > 0 then
			require("nvim-treesitter").install(missing)
		end
	end, 500)

	-- setup treesitter highlighting
	vim.api.nvim_create_autocmd("FileType", {
		group = augroup,
		pattern = "*",
		callback = function(args)
			local filetype = vim.bo[args.buf].filetype
			local lang = vim.treesitter.language.get_lang(filetype) or filetype

			pcall(vim.treesitter.start, args.buf, lang)
			vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end,
	})
end

return M
