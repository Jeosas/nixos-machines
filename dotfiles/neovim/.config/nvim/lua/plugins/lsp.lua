-- =============================================================================
-- LSP Configuration
-- =============================================================================

-- LspAttach autocmd: keymaps and features on buffer attach
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("nvimpack-lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buf = event.buf, desc = "LSP: " .. desc })
		end

		local snacks = require("snacks")

		map("gl", vim.diagnostic.open_float, "Open diagnostic float")
		map("<leader>ld", snacks.picker.lsp_definitions, "Go to definition")
		map("<leader>lD", vim.lsp.buf.declaration, "Go to declaration")
		map("<leader>lr", snacks.picker.lsp_references, "Go to references")
		map("<leader>li", snacks.picker.lsp_implementations, "Go to implementation")
		map("<leader>lI", function()
			vim.cmd("checkhealth vim.lsp")
		end, "Go to implementation")
		map("<leader>ls", snacks.picker.lsp_symbols, "Lsp document symbols")
		map("<leader>lS", snacks.picker.lsp_workspace_symbols, "Lsp workspace symbols")
		map("<leader>lr", vim.lsp.buf.rename, "Rename")
		map("<leader>la", vim.lsp.buf.code_action, "Code Action", { "n", "x" })

		-- Native floats routed through vim.lsp.buf.* opts (vim.lsp.with is deprecated).
		map("K", function()
			vim.lsp.buf.hover({
				border = "single",
				max_width = 80,
				max_height = 20,
			})
		end, "Hover Documentation")

		-- <C-s> is Neovim's global default (defaults.lua:251); this buffer-local map
		-- shadows it to add float options, keeping the same key.
		map("<C-s>", function()
			vim.lsp.buf.signature_help()
		end, "Signature Help", "i")

		local client = vim.lsp.get_client_by_id(event.data.client_id)

		-- Document highlight on cursor hold
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
			local highlight_augroup = vim.api.nvim_create_augroup("nvimpack-lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buf = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buf = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})
			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("nvimpack-lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "nvimpack-lsp-highlight", buf = event2.buf })
				end,
			})
		end

		-- Inlay hints: enable on attach, toggle keymap
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
			vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
			map("<leader>lh", function()
				local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
				vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
			end, "Toggle Inlay Hints")
		end
	end,
})

-- Inlay hints: disable during insert mode to prevent race conditions where
-- rapid buffer edits (e.g. auto-completion) invalidate hint positions before
-- Neovim renders them, causing "Invalid 'col': out of range" errors.
-- vim.schedule on InsertLeave delays the re-enable until the buffer has settled.
vim.api.nvim_create_autocmd("InsertEnter", {
	group = vim.api.nvim_create_augroup("nvimpack-inlay-hints-insert", { clear = true }),
	callback = function(event)
		vim.lsp.inlay_hint.enable(false, { bufnr = event.buf })
	end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
	group = "nvimpack-inlay-hints-insert",
	callback = function(event)
		vim.schedule(function()
			if vim.api.nvim_buf_is_valid(event.buf) then
				vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
			end
		end)
	end,
})

-- Diagnostic display config

local signs = {
	{ name = "DiagnosticSignError", text = "" },
	{ name = "DiagnosticSignWarn", text = "" },
	{ name = "DiagnosticSignHint", text = "" },
	{ name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(signs) do
	vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

vim.diagnostic.config({
	virtual_text = true,
	signs = { active = signs },
	update_in_insert = true,
	underline = true,
	severity_sort = true,
	float = {
		border = "single",
		source = "if_many",
		header = "",
		prefix = "",
		max_width = 80,
		max_height = 20,
	},
})

-- LSP progress -> native terminal progress (OSC 9;4).
-- LSP emits LspProgress, not Progress; bridge directly to the terminal.
if vim.fn.has("nvim-0.12") == 1 then
	local group = vim.api.nvim_create_augroup("nvimpack-lsp-progress", { clear = true })
	local active = {} ---@type table<integer, table<string|integer, { percentage?: integer }>>
	local has_ui = #vim.api.nvim_list_uis() > 0
	local last_osc = nil

	local function send_osc(seq)
		if not has_ui or seq == last_osc then
			return
		end
		if pcall(vim.api.nvim_ui_send, seq) then
			last_osc = seq
		end
	end

	local function recompute()
		local max_percent = nil
		local any = false
		for _, tokens in pairs(active) do
			for _, token in pairs(tokens) do
				any = true
				if token.percentage then
					max_percent = math.max(max_percent or 0, token.percentage)
				end
			end
		end

		if not any then
			send_osc("\027]9;4;0;0\027\\")
		elseif max_percent then
			send_osc(string.format("\027]9;4;1;%d\027\\", max_percent))
		else
			send_osc("\027]9;4;3\027\\")
		end
	end

	local function sync_ui()
		has_ui = #vim.api.nvim_list_uis() > 0
		last_osc = nil
		recompute()
	end

	vim.api.nvim_create_autocmd("UIEnter", {
		group = group,
		callback = sync_ui,
	})

	vim.api.nvim_create_autocmd("UILeave", {
		group = group,
		callback = sync_ui,
	})

	vim.api.nvim_create_autocmd("LspProgress", {
		group = group,
		callback = function(ev)
			local data = ev.data
			local value = data.params.value
			local client_id = data.client_id
			local token_id = data.params.token
			if token_id == nil then
				return
			end
			local tokens = active[client_id]
			if not tokens then
				tokens = {}
				active[client_id] = tokens
			end

			if value.kind == "end" then
				tokens[token_id] = nil
				if next(tokens) == nil then
					active[client_id] = nil
				end
			else
				local percentage = value.percentage
				if type(percentage) == "number" then
					percentage = math.max(0, math.min(100, percentage))
				else
					percentage = nil
				end
				local token = tokens[token_id]
				if token then
					token.percentage = percentage
				else
					tokens[token_id] = { percentage = percentage }
				end
			end

			recompute()
		end,
	})

	vim.api.nvim_create_autocmd("LspDetach", {
		group = group,
		callback = function(ev)
			local client = vim.lsp.get_client_by_id(ev.data.client_id)
			if not client or client:is_stopped() then
				active[ev.data.client_id] = nil
				recompute()
			end
		end,
	})

	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = group,
		callback = function()
			last_osc = nil
			send_osc("\027]9;4;0;0\027\\")
		end,
	})
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = { "documentation", "detail", "additionalTextEdits" },
}

-- ===========================================================================
-- LSP Server Helpers
-- ===========================================================================

local servers = {
	bashls = {},
	cssls = {
		filetypes = { "jinja.html" },
	},
	elmls = {},
	emmet_language_server = { filetypes = { "jinja.html" } },
	gopls = {},
	helm_ls = { filetypes = { "helm" } },
	html = { filetypes = { "jinja.html" } },
	jsonls = {
		settings = { json = { schemas = require("schemastore").json.schemas({}), validate = { enable = true } } },
	},
	lua_ls = {
		settings = {
			Lua = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					version = { version = "max" },
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		},
	},
	marksman = {},
	nil_ls = { settings = { ["nil"] = { formatting = { command = { "nixfmt" } } } } },
	pylsp = {},
	rust_analyzer = { settings = { ["rust-analyzer"] = { cargo = { allFeatures = true } } } },
	svelte = {},
	tailwindcss = { filetypes = { "jinja.html" } },
	taplo = {},
	terraformls = {},
	texlab = {},
	tinymist = {},
	ts_ls = {},
	yamlls = {
		filetypes = { "yaml", "yaml.ghaction" },
		settings = {
			yaml = {
				schemaStore = { enable = false, url = "" },
				schemas = require("schemastore").yaml.schemas({}),
			},
		},
	},
}

for server_name, server_config in pairs(servers) do
	server_config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server_config.capabilities or {})
	vim.lsp.config(server_name, server_config)
	vim.lsp.enable(server_name)
end
