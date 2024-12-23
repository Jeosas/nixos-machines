{ ... }:
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
        function _G.set_terminal_keymaps()
        	local opts = { noremap = true }
        	vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
        	vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
        	vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
        	vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
        	vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
        end

        vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

        local Terminal = require("toggleterm.terminal").Terminal

        -- lazygit
        local lazygit = Terminal:new({
        	cmd = "lazygit",
        	hidden = true,
        	on_open = function(term)
        		vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<esc>", "<esc>", { noremap = true, silent = true })
        	end,
        	on_close = function(term)
        		vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<esc>", "[[<C-><C-n>]]", { noremap = true, silent = true })
        	end,
        })

        function _LAZYGIT_TOGGLE()
        	lazygit:toggle()
        end
      '';
  };
}
