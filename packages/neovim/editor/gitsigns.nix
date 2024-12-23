{ ... }:
{
  autoCmd = [
    {
      event = [ "FileType" ];
      pattern = [ "gitsigns-blame" ];
      command = "nnoremap <silent> <buffer> q :bd<CR>";
    }
  ];

  keymaps =
    let
      options = {
        noremap = true;
        silent = true;
      };
    in
    [
      {
        mode = "n";
        key = "<leader>gb";
        action = "<cmd>Gitsigns blame<cr>";
        inherit options;
      }
      {
        mode = "n";
        key = "<leader>gd";
        action = "<cmd>Gitsigns diffthis HEAD<cr>";
        inherit options;
      }
      {
        mode = "n";
        key = "<leader>gr";
        action = "<cmd>Gitsigns reset_hunk<cr>";
        inherit options;
      }
      {
        mode = "n";
        key = "<leader>gR";
        action = "<cmd>Gitsigns reset_buffer<cr>";
        inherit options;
      }
      {
        mode = "n";
        key = "<leader>gj";
        action = "<cmd>Gitsigns toggle_deleted<cr>";
        inherit options;
      }
    ];

  plugins.gitsigns = {
    enable = true;
    settings = {
      attach_to_untracked = true;
    };
  };
}
