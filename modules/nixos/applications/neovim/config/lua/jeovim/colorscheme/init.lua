local theme = "nord"

local require_ok, _ = pcall(require, "jeovim.colorscheme." .. theme)
if not require_ok then
	vim.notify("Couldn't find theme '" .. theme .. "'.")
end
