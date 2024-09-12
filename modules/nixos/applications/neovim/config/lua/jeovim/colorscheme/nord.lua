-- Load the colorscheme
vim.g.nord_borders = true
vim.g.nord_disable_background = true
vim.g.nord_cursorline_transparent = true

require("nord").set()

vim.cmd([[
  augroup nord-theme-overrides
    autocmd!
    autocmd ColorScheme nord highlight GitLens ctermfg=14 gui=italic guifg=#616e88
  augroup END
]])

vim.cmd([[colorscheme nord]])
