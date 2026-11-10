local cmp = require("cmp")

cmp.setup({
	experimental = { ghost_text = true },
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, item)
			local icons = {
				Namespace = "󰌗",
				Text = "󰉿",
				Method = "󰆧",
				Function = "󰆧",
				Constructor = "",
				Field = "󰜢",
				Variable = "󰀫",
				Class = "󰠱",
				Interface = "",
				Module = "",
				Property = "󰜢",
				Unit = "󰑭",
				Value = "󰎠",
				Enum = "",
				Keyword = "󰌋",
				Snippet = "",
				Color = "󰏘",
				File = "󰈚",
				Reference = "󰈇",
				Folder = "󰉋",
				EnumMember = "",
				Constant = "󰏿",
				Struct = "󰙅",
				Event = "",
				Operator = "󰆕",
				TypeParameter = "󰊄",
				Table = "",
				Object = "󰅩",
				Tag = "",
				Array = "󰅩",
				Boolean = "",
				Number = "",
				Null = "󰟢",
				String = "󰉿",
				Calendar = "",
				Watch = "󰥔",
				Package = "",
			}

			item.kind = string.format("%s", icons[item.kind])
			item.menu = ({
				nvim_lsp = "[LSP]",
				luasnip = "[Snippet]",
				buffer = "[Buffer]",
				path = "[Path]",
			})[entry.source.name]
			return item
		end,
	},
	mapping = {
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-j>"] = cmp.mapping.select_next_item(),
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<Down>"] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif require("luasnip").expand_or_jumpable() then
				vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
			else
				fallback()
			end
		end,
		["<S-Tab>"] = cmp.mapping.close(),
		["<Tab>"] = function(fallback)
			local line = vim.api.nvim_get_current_line()
			if line:match("^%s*$") then
				fallback()
			elseif cmp.visible() then
				cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
			else
				fallback()
			end
		end,
		["<Up>"] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif require("luasnip").jumpable(-1) then
				vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
			else
				fallback()
			end
		end,
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer", option = { get_bufnrs = vim.api.nvim_list_bufs } },
		{ name = "path" },
	},
	window = {
		completion = { scrollbar = false },
	},
})
