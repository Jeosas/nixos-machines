function options()
	vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
	vim.opt.cmdheight = 2 -- more space in the neovim command line for displaying messages
	-- vim.opt.completeopt = { "menuone", "noselect" } -- mostly just for cmp
	vim.opt.hlsearch = false -- don't highlight matches on previous search pattern
	vim.opt.incsearch = true -- show current search match during typing
	vim.opt.ignorecase = true -- ignore case in search patterns
	vim.opt.smartcase = true -- override ignorecase if Uppercase are used in search
	vim.opt.mouse = "" -- disable mouse support
	vim.opt.pumheight = 10 -- max number of items to show in the popup menu
	vim.opt.showmode = false -- don't show mode
	vim.opt.showtabline = 2 -- always show tabline
	-- vim.opt.smartindent = true -- make indenting smarter again
	vim.opt.splitbelow = true -- force all horizontal splits to go below current window
	vim.opt.splitright = true -- force all vertical splits to go to the right of current window
	vim.opt.swapfile = false -- don't create swapfiles
	vim.opt.termguicolors = true -- set term gui colors (most terminals support this)
	vim.opt.timeoutlen = 300 -- time to wait for a mapped sequence to complete (in milliseconds)
	vim.opt.undofile = true -- enable persistent undo
	vim.opt.updatetime = 50 -- faster completion (4000ms default)
	vim.opt.writebackup = false -- if a file is being edited by another program, it is not allowed to be edited
	vim.opt.expandtab = true -- use spaces instead of tabs, fucks up lsp formatters
	vim.opt.shiftwidth = 2 -- the number of spaces inserted for each indentation
	vim.opt.tabstop = 2 -- insert 4 spaces for a tab
	vim.opt.softtabstop = 2 -- fake tab insertion with space during editing
	vim.opt.cursorline = true -- highlight the current line
	vim.opt.number = true -- set numbered lines
	vim.opt.relativenumber = true -- set relative numbered lines
	vim.opt.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
	vim.opt.wrap = false -- no line wrap
	vim.opt.shortmess:append("c") -- helps to avoid all the hit-enter prompts
	vim.opt.guicursor = "" -- disable cursor styling
	vim.opt.scrolloff = 8 -- always keep an 8 line padding when scrollig up/down
end

options()
