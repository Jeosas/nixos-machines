{...}: {
  plugins.telescope = {
    enable = true;

    keymaps = {
      "<leader><leader>" = "find_files";
      "<leader>ff" = "find_files";
      "<leader>fr" = "oldfiles";
      "<leader>fw" = "live_grep theme=ivy";

      "<leader>b" = "buffers";
      "<leader>s" = "spell_suggest";
      "<leader>t" = "treesitter";
      "<leader>u" = "undo";
      "<leader>." = "help_tags";
      "<leader>?" = "keymaps";
    };

    settings = {
      defaults = {
        prompt_prefix = " ";
        selection_caret = " ";
        path_display = ["smart"];
      };
    };

    extensions = {
      undo = {
        enable = true;
        settings = {
          mappings.i = {
            "<cr>" = "require('telescope-undo.actions').restore";
            "<c-cr>" = "require('telescope-undo.actions').yank_additions";
          };
        };
      };
    };
  };
}
