{ inputs, config, pkgs, lib, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal.family = "Hack Nerd Font Mono";
        size = 7;
      };

      colors = with config.colors; {

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
}

