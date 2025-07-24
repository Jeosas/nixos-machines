{
  lib,
  namespace,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.yazi;
in
{
  options.${namespace}.apps.yazi = {
    enable = mkEnableOption "yazi";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.${namespace}.user.enableHomeManager;
        message = "Home-manager is not enabled.";
      }
    ];

    home-manager.users.${config.${namespace}.user.name} = {
      programs.yazi = {
        enable = true;
        enableZshIntegration = config.${namespace}.apps.zsh.enable;
        enableBashIntegration = config.${namespace}.apps.bash.enable;

        settings = {
          mgr = {
            show_hidden = true;
            show_simlink = true;
            scrolloff = 6; # scroll offset
            sort_by = "alphabetical";
            sort_dir_first = true;
            line_mode = "mtime";
          };
        };
        keymap = {
          mgr.prepend_keymap = [
            {
              on = [ "l" ];
              run = "plugin smart-enter";
              desc = "Enter the child directory, or open the file";
            }
            {
              on = [ "T" ];
              run = "plugin toggle-pane max-preview";
              desc = "Toggle maximized preview";
            }
          ];
        };
        initLua =
          # lua
          ''
            require("full-border"):setup {
            	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
            	type = ui.Border.ROUNDED,
            }
          '';
        plugins = {
          smart-enter = "${inputs.yazi-plugins}/smart-enter.yazi";
          toggle-pane = "${inputs.yazi-plugins}/toggle-pane.yazi";
          full-border = "${inputs.yazi-plugins}/full-border.yazi";
        };
      };
    };
  };
}
