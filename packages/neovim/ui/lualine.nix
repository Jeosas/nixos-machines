{...}: let
  mode = {
    __unkeyed-1 = "mode";
    color = {gui = "bold";};
  };
  file_type = {
    __unkeyed-1 = "filetype";
    icon_only = true;
    colored = true;
    padding = {
      left = 1;
      right = 0;
    };
  };
  file_name = {
    __unkeyed-1 = "filename";
    file_status = true;
    symbols = {
      modified = "";
      readonly = "";
      unnamed = "[No Name]";
      newfile = "[New]";
    };
  };

  git_branch = {
    __unkeyed-1 = "branch";
    icons_enabled = true;
    icon = "";
  };

  git_diff = {
    __unkeyed-1 = "diff";
    colored = false;
    symbols = {
      added = " ";
      modified = " ";
      removed = " ";
    };
  };

  lsp_diagnostics = {
    __unkeyed-1 = "diagnostics";
    sources = ["nvim_diagnostic"];
    sections = ["error" "warn"];
    symbols = {
      error = " ";
      warn = " ";
    };
  };

  cur_position = {
    __unkeyed-1 = "location";
    padding = 1;
  };
in {
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        icons_enabled = true;
        # theme = "nord";
        component_separators = {
          left = "";
          right = "";
        };
        section_separators = {
          left = "";
          right = "";
        };
        disabled_filetypes = ["alpha" "dashboard" "Outline"];
        always_divide_middle = true;
        globalstatus = true;
      };
      sections = {
        lualine_a = [mode];
        lualine_b = [file_type file_name];
        lualine_c = [git_branch git_diff];
        lualine_x = [lsp_diagnostics];
        lualine_y = [];
        lualine_z = [cur_position];
      };
      inactive_sections = {
        lualine_a = [];
        lualine_b = [];
        lualine_c = [file_type file_name];
        lualine_x = [cur_position];
        lualine_y = [];
        lualine_z = [];
      };
      tabline = {};
      winbar = {};
      extensions = [];
    };
  };
}
