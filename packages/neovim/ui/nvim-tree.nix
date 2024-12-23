{ lib, ... }:
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
    hijackCursor = true;
    respectBufCwd = true;
    syncRootWithCwd = true;
    updateFocusedFile = {
      enable = true;
      updateRoot = true;
    };
    diagnostics = {
      enable = true;
      showOnDirs = true;
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
      openFile = {
        quitOnOpen = true;
      };
    };
    renderer = {
      rootFolderLabel = ":t";
      icons = {
        glyphs = {
          default = "";
          symlink = "";
          folder = {
            arrowOpen = "";
            arrowClosed = "";
            default = "";
            open = "";
            empty = "";
            emptyOpen = "";
            symlink = "";
            symlinkOpen = "";
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
    onAttach.__raw =
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
}
