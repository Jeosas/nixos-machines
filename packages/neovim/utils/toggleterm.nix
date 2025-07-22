{ _, ... }:
{
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
        key = "<leader>o";
        action = "<cmd>ToggleTerm direction=float<cr>";
        inherit options;
      }
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>lua _LAZYGIT_TOGGLE()<cr>";
        inherit options;
      }
      {
        mode = "n";
        key = "<leader>jj";
        action = "<cmd>TermExec cmd=\"jj log\" go_back=0<cr>";
        inherit options;
      }
    ];

  plugins.toggleterm = {
    enable = true;
    settings = {
      direction = "float";
      size = 20;
      shading_factor = 2;
      float_opts = {
        border = "single";
        highlights = {
          border = "Normal";
          background = "Normal";
        };
      };
    };

    luaConfig.post =
      #lua
      ''
        local Terminal = require("toggleterm.terminal").Terminal

        -- lazygit
        local lazygit = Terminal:new({
        	cmd = "lazygit",
        	hidden = true,
        })

        function _LAZYGIT_TOGGLE()
        	lazygit:toggle()
        end
      '';
  };
}
