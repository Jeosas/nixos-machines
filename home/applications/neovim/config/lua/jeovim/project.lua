local ts_utils = require("nvim-treesitter.ts_utils")

local status_ok, project = pcall(require, "project_nvim")
if not status_ok then
	return
end
project.setup({
	---@usage set to false to disable project.nvim.
	--- This is on by default since it's currently the expected behavior.
	active = true,

	on_config_done = nil,

	---@usage set to true to disable setting the current-woriking directory
	--- Manual mode doesn't automatically change your root directory, so you have
	--- the option to manually do so using `:ProjectRoot` command.
	manual_mode = false,

	---@usage Methods of detecting the root directory
	--- Allowed values: **"lsp"** uses the native neovim lsp
	--- **"pattern"** uses vim-rooter like glob pattern matching. Here
	--- order matters: if one is not detected, the other is used as fallback. You
	--- can also delete or rearangne the detection methods.
	-- detection_methods = { "lsp", "pattern" }, -- NOTE: lsp detection will get annoying with multiple langs in one project
	detection_methods = { "pattern" },

	---@usage patterns used to detect root dir, when **"pattern"** is in detection_methods
	patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "pyproject.toml", "Cargo.toml" },

	---@ Show hidden files in telescope when searching for files in a project
	show_hidden = false,

	---@usage When set to false, you will get a message when project.nvim changes your directory.
	-- When set to false, you will get a message when project.nvim changes your directory.
	silent_chdir = true,

	---@usage list of lsp client names to ignore when using **lsp** detection. eg: { "efm", ... }
	ignore_lsp = {},

	---@type string
	---@usage path to store the project history for use in telescope
	datapath = vim.fn.stdpath("data"),
})

local tele_status_ok, telescope = pcall(require, "telescope")
if not tele_status_ok then
	return
end

telescope.load_extension("projects")

------------------
-- awesomess <3 --
------------------

local supported_types = {
	python = {
		test_all = "pytest -s",
		test_function = function()
			vim.treesitter.get_node_at_cursor()
			local function_name
			local node_at_point = ts_utils.get_node_at_cursor()

			if not node_at_point then
				return nil
			end

			while node_at_point do
				if not node_at_point then
					break
				end
				if node_at_point:type() == "function_definition" then
					function_name = vim.treesitter.query.get_node_text(
						node_at_point:field("name")[1],
						vim.api.nvim_get_current_buf()
					)
					if string.match(function_name, "^test_") then
						break
					end
				end
				node_at_point = node_at_point:parent()
			end

			if function_name then
				return "pytest " .. vim.api.nvim_buf_get_name(0) .. " -s -k " .. function_name
			end
			vim.notify("Coudn't find test function.", "error")
		end,
		dep_add = "poetry add",
		dep_install = "poetry install",
		check = nil,
		run = nil,
	},
	rust = {
		test_all = "cargo test",
		test_function = function()
			vim.treesitter.get_node_at_cursor()
			local function_name
			local node_at_point = ts_utils.get_node_at_cursor()

			if not node_at_point then
				return nil
			end

			while node_at_point do
				if not node_at_point then
					break
				end
				if node_at_point:type() == "function_item" then
					if
						node_at_point.prev_sibling().type() == "attribute_item"
						and node_at_point.prev_sibling().child().type() == "meta_item"
					then
						if
							vim.treesitter.query.get_node_text(
								node_at_point:prev_sibling().child().child(),
								vim.api.nvim_get_current_buf()
							) == "test"
						then
							fonction_name = vim.treesitter.query.get_node_text(
								node_at_point:field("name")[1],
								vim.api.nvim_get_current_buf()
							)
							break
						end
					end
				end
				node_at_point = node_at_point:parent()
			end

			if function_name then
				return "cargo test " .. function_name
			end
			vim.notify("Coudn't find test function.", "error")
		end,
		dep_add = "cargo add",
		dep_install = "cargo fetch",
		check = "cargo check",
		run = "cargo run --",
	},
}

Terminal = require("jeovim.toggleterm").terminal

local function get_command(command_name)
	local lang_commands = supported_types[vim.bo.filetype]
	if not lang_commands then
		vim.notify("Unsupported project lang: " .. vim.bo.filetype, "error")
		return nil
	end

	local command = lang_commands[command_name]
	if not command then
		vim.notify(vim.bo.filetype .. " doesn't support " .. command_name, "error")
		return nil
	end

	if type(command) == "function" then
		return command()
	end

	return command
end

function _PROJECT_TEST_FUNCTION() -- run test under cursor
	local command = get_command("test_function")
	if not command then
		return
	end
	local term = Terminal:new({
		cmd = command,
		direction = "horizontal",
		close_on_exit = false,
		on_open = function(term)
			vim.cmd("stopinsert")
		end,
	})
	term:open()
end

function _PROJECT_TEST_ALL()
	local command = get_command("test_all")
	if not command then
		return
	end
	Terminal:new({
		cmd = command,
		direction = "horizontal",
		close_on_exit = false,
		on_open = function(term)
			vim.cmd("stopinsert")
		end,
	}):open()
end

function _PROJECT_DEP_INSTALL()
	local command = get_command("dep_install")
	if not command then
		return
	end
	Terminal:new({
		cmd = command,
		direction = "float",
		close_on_exit = false,
		on_open = function(term)
			vim.cmd("stopinsert")
		end,
	}):open()
end

function _PROJECT_DEP_ADD()
	local command = get_command("dep_add")
	if not command then
		return
	end
	vim.ui.input({ prompt = "Dependency to add:" }, function(input)
		if not input then
			return
		end
		Terminal:new({
			cmd = command .. " " .. input,
			direction = "float",
			close_on_exit = false,
			on_open = function(term)
				vim.cmd("stopinsert")
			end,
		}):open()
	end)
end

function _PROJECT_CHECK()
	local command = get_command("check")
	if not command then
		return
	end
	Terminal:new({
		cmd = command,
		direction = "horizontal",
		close_on_exit = false,
		on_open = function(term)
			vim.cmd("stopinsert")
		end,
	}):open()
end

function _PROJECT_RUN()
	local command = get_command("run")
	if not command then
		return
	end
	vim.ui.input({ prompt = "Run args:", completion = "arglist" }, function(input)
		if not input then
			return
		end
		Terminal:new({
			cmd = command .. " " .. input,
			direction = "horizontal",
			close_on_exit = false,
			on_open = function(term)
				vim.cmd("stopinsert")
			end,
		}):open()
	end)
end
