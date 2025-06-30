{ _, ... }:

{
  keymaps = [
    {
      mode = "n";
      key = "<leader>a";
      action = "<cmd>AerialToggle right<cr>";
      options = {
        noremap = true;
        silent = true;
      };
    }
  ];

  plugins.aerial = {
    enable = true;
    settings = {
      attach_mode = "window";
      on_attach.__raw =
        # lua
        ''
          function(bufnr)
            -- Jump forwards/backwards with '{' and '}'
            vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
            vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
          end
        '';
      autojump = true;
      close_automatic_events = [
        "unfocus"
        "switch_buffer"
      ];
      close_on_select = true;
      disable_max_lines = 10000;
      disable_max_size = 2000000; # Mb
    };
  };
}
