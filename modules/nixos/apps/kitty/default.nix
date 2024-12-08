{
  lib,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.apps.kitty;
in
  with lib; {
    options.${namespace}.apps.kitty = {enable = mkEnableOption "kitty";};

    config = mkIf cfg.enable {
      home-manager.users.${config.${namespace}.user.name} = {
        programs.kitty = {
          enable = true;
          font = {
            inherit (config.${namespace}.theme.fonts.mono) name package;
            size = 11;
          };
          shellIntegration.mode = "disabled";
          settings = mkMerge [
            config.${namespace}.theme.colors
            {
              background_opacity = "0.9";
              dynamic_background_opacity = true;

              bold_font = "${config.${namespace}.theme.fonts.mono.name} Bold";
              italic_font = "${config.${namespace}.theme.fonts.mono.name} Italic";
              bold_italic_font = "${config.${namespace}.theme.fonts.mono.name} Bold Italic";
              "modify_font cell_width" = "110%";
              disable_ligatures = "always";

              cursor_shape = "block";
              cursor_trail = 1;
              cursor_trail_decay = "0.1 0.4";

              enable_audio_bell = false;
              mouse_hide_wait = 0;
              tab_bar_style = "hidden";
            }
          ];
        };
      };
    };
  }
