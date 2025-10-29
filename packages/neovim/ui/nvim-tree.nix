{ _, ... }:
{
  keymaps = [
    {
      mode = "n";
      key = "<leader>e";
      action = "<cmd>NvimTreeToggle<cr>";
      options = {
        noremap = true;
        silent = true;
      };
    }
  ];

  plugins.nvim-tree = {
    enable = true;
    autoClose = true;
    settings = {
      hijack_cursor = true;
      respect_buf_cwd = true;
      sync_root_with_cwd = true;
      update_focused_file = {
        enable = true;
        update_root = true;
      };
      diagnostics = {
        enable = true;
        show_on_dirs = true;
        icons = {
          hint = "󱠂";
          info = "";
          warning = "";
          error = "";
        };
      };
      view = {
        side = "left";
        width = {
          min = 30;
          max = "25%";
        };
      };
      actions = {
        open_file = {
          quit_on_open = true;
        };
      };
      renderer = {
        root_folder_label = ":t";
        icons = {
          glyphs = {
            default = "";
            symlink = "";
            folder = {
              arrow_open = "";
              arrow_closed = "";
              default = "";
              open = "";
              empty = "";
              empty_open = "";
              symlink = "";
              symlink_open = "";
            };
            git = {
              unstaged = "";
              staged = "S";
              unmerged = "";
              renamed = "➜";
              untracked = "U";
              deleted = "";
              ignored = "◌";
            };
          };
        };
      };
      on_attach.__raw =
        #lua
        ''
          function(bufnr)
          	local api = require("nvim-tree.api")

          	local function opts(desc)
          		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          	end

          	api.config.mappings.default_on_attach(bufnr)

          	vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
          	vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close"))
          end
        '';
    };
  };
}
