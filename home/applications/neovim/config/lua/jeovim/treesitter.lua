-- custom extensions
vim.treesitter.language.register("hcl", "nomad")

require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
	},
	autopairs = {
		enable = true,
	},
	indent = { enable = true },
})
