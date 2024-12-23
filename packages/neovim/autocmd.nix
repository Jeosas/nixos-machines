{...}: {
  autoCmd = [
    {
      event = ["FileType"];
      pattern = ["qf" "help" "man"];
      command = "nnoremap <silent> <buffer> q :close<CR>";
    }
    {
      event = ["TextYankPost"];
      pattern = ["*"];
      command = "silent!lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200})";
    }
    {
      event = ["BufWinEnter"];
      pattern = ["*"];
      command = ":set formatoptions-=cro";
    }
    {
      event = ["FileType"];
      pattern = ["qf"]; # quick fix window
      command = "set nobuflisted";
    }
  ];
}
