{lib, ...}: {
  opts = {
    hlsearch = false; # don't highlight matches on previous search pattern
    incsearch = true; # show current search match during typing
    ignorecase = true; # ignore case in search patterns
    smartcase = true; # override ignorecase if Uppercase are used in search
    mouse = ""; # disable mouse support
    pumheight = 10; # max number of items to show in the popup menu
    showmode = false; # don't show mode
    splitbelow = true; # force all horizontal splits to go below current window
    splitright = true; # force all vertical splits to go to the right of current window
    swapfile = false; # don't create swapfiles
    termguicolors = true; # set term gui colors (most terminals support this)
    timeoutlen = 300; # time to wait for a mapped sequence to complete (in milliseconds)
    undofile = true; # enable persistent undo
    updatetime = 50; # faster completion (4000ms default)
    writebackup = false; # if a file is being edited by another program, it is not allowed to be edited
    expandtab = true; # use spaces instead of tabs, fucks up lsp formatters
    shiftwidth = 2; # the number of spaces inserted for each indentation
    tabstop = 2; # spaces inserted for a tab
    softtabstop = 2; # fake tab insertion with space during editing
    cursorline = true; # highlight the current line
    number = true; # set numbered lines
    relativenumber = true; # set relative numbered lines
    signcolumn = "yes"; # always show the sign column, otherwise it would shift the text each time
    wrap = false; # no line wrap
    # shortmess:append("c"); # helps to avoid all the hit-enter prompts
    guicursor = ""; # disable cursor styling
    scrolloff = 8; # always keep an 8 line padding when scrollig up/down
  };
}
