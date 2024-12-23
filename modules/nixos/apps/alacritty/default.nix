{
  lib,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.apps.alacritty;
in
with lib;
{
  options.${namespace}.apps.alacritty = {
    enable = mkEnableOption "alacritty";
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.${namespace}.user.name} = {
      programs.alacritty = {
        enable = true;
        settings = {
          font = {
            normal.family = config.${namespace}.theme.fonts.mono.name;
            size = 11;
            offset.x = 1;
          };

          window = {
            opacity = 0.9;
            decorations = "None";
          };

          colors = with config.${namespace}.theme.colors; {
            primary = {
              background = background;
              foreground = foreground;
            };
            cursor = {
              text = background;
              cursor = foreground;
            };
            vi_mode_cursor = {
              text = background;
              cursor = foreground;
            };
            selection = {
              text = "CellForeground";
              background = color8;
            };
            search = {
              matches = {
                foreground = "CellBackground";
                background = color6;
              };
            };
            footer_bar = {
              background = "#434c5e";
              foreground = foreground;
            };

            normal = {
              black = color0;
              red = color1;
              green = color2;
              yellow = color3;
              blue = color4;
              magenta = color5;
              cyan = color6;
              white = color7;
            };
            bright = {
              black = color8;
              red = color9;
              green = color10;
              yellow = color11;
              blue = color12;
              magenta = color13;
              cyan = color14;
              white = color15;
            };
          };
        };
      };
    };
  };
}
