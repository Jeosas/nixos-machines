{ config, pkgs, lib, ... }:

let
  brightness = import ./brightnessScript.nix { inherit pkgs; };
  screenlock = import ./screenlockScript.nix { inherit pkgs; colors = config.colors; };
  volume = import ./volumeScript.nix { inherit pkgs; };
in
{
  home.packages = with pkgs; [
    coreutils
    gawk
  ];

  xsession.windowManager.i3 = {
    enable = true;
    config =
      let
        colors = {
          foreground = config.colors.foreground;
          background = config.colors.background;
          primary = config.colors.color10;
          warning = config.colors.color1;
        };
        mod = "Mod4";
        terminal = "i3-sensible-terminal";
      in
      {
        bars = [ ];
        colors = {
          background = colors.background;
          focused = {
            background = colors.background;
            border = colors.primary;
            childBorder = colors.primary;
            indicator = colors.primary;
            text = colors.foreground;
          };
          focusedInactive = {
            background = colors.background;
            border = colors.background;
            childBorder = colors.background;
            indicator = colors.foreground;
            text = colors.foreground;
          };
          unfocused = {
            background = colors.background;
            border = colors.background;
            childBorder = colors.background;
            indicator = colors.foreground;
            text = colors.foreground;
          };
          urgent = {
            background = colors.background;
            border = colors.warning;
            childBorder = colors.warning;
            indicator = colors.warning;
            text = colors.foreground;
          };
        };
        floating = {
          border = 0;
          criteria = [
            {
              class = "dpets";
            }
          ];
          titlebar = false;
        };
        focus = {
          followMouse = false;
        };
        gaps = {
          inner = 3;
          outer = 3;
          smartGaps = true;
        };
        keybindings = {
          "XF86MonBrightnessUp" = "exec ${brightness} up";
          "XF86MonBrightnessDown" = "exec ${brightness} down";

          "XF86AudioRaiseVolume" = "exec ${volume} up";
          "XF86AudioLowerVolume" = "exec ${volume} down";
          "XF86AudioMute" = "exec ${volume} mute";

          "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioPause" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioStop" = "exec ${pkgs.playerctl}/bin/playerctl stop";
          "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
          "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";

          "Print" = "exec ${pkgs.flameshot}/bin/flameshot screen";
          "Shift+Print" = "exec ${pkgs.flameshot}/bin/flameshot gui -s -p ~/images";

          "${mod}+Shift+q" = "exec ~/.config/rofi/menus/power";
          "${mod}+p" = "exec ~/.config/rofi/menus/display";
          "${mod}+Shift+d" = "exec ${screenlock}";
          "${mod}+Shift+a" = "kill";
          "${mod}+d" = "exec ~/.config/rofi/menus/apps";
          "${mod}+Return" = "exec ${terminal}";
          "${mod}+Shift+Return" = "exec ${config.programs.firefox.package}/bin/firefox";
          "${mod}+Shift+r" = "restart";

          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";
          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+l" = "move right";
          "${mod}+Ctrl+Shift+h" = "move workspace to output left";
          "${mod}+Ctrl+Shift+j" = "move workspace to output down";
          "${mod}+Ctrl+Shift+k" = "move workspace to output up";
          "${mod}+Ctrl+Shift+l" = "move workspace to output right";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+space" = "floating toggle";

          "${mod}+1" = "workspace number 1";
          "${mod}+2" = "workspace number 2";
          "${mod}+3" = "workspace number 3";
          "${mod}+4" = "workspace number 4";
          "${mod}+5" = "workspace number 5";
          "${mod}+6" = "workspace number 6";
          "${mod}+7" = "workspace number 7";
          "${mod}+8" = "workspace number 8";
          "${mod}+9" = "workspace number 9";
          "${mod}+10" = "workspace number 10";
          "${mod}+Shift+1" = "move container to workspace number 1";
          "${mod}+Shift+2" = "move container to workspace number 2";
          "${mod}+Shift+3" = "move container to workspace number 3";
          "${mod}+Shift+4" = "move container to workspace number 4";
          "${mod}+Shift+5" = "move container to workspace number 5";
          "${mod}+Shift+6" = "move container to workspace number 6";
          "${mod}+Shift+7" = "move container to workspace number 7";
          "${mod}+Shift+8" = "move container to workspace number 8";
          "${mod}+Shift+9" = "move container to workspace number 9";
          "${mod}+Shift+10" = "move container to workspace number 10";

          "${mod}+r" = "mode resize";
        };
        modes = {
          resize = {
            h = "resize shrink width 10 px or 10 ppt";
            j = "resize grow height 10 px or 10 ppt";
            k = "resize shrink height 10 px or 10 ppt";
            l = "resize grow width 10 px or 10 ppt";
            Return = "mode default";
            Escape = "mode default";
            "${mod}+r" = "mode default";
          };
        };
        modifier = mod;
        startup = [
          { command = "${pkgs.feh}/bin/feh --no-fehbg -z --bg-fill ~/Images/wallpapers"; }
          { command = "${pkgs.dunst}/bin/dunst &"; }
          { command = "${pkgs.polybar}/bin/polybar main &"; }
        ];
        terminal = terminal;
        window = {
          border = 2;
          commands = [
            {
              command = "border pixel 0";
              criteria = {
                class = "dpets";
              };
            }
          ];
          titlebar = false;
        };
      };
  };

  home.file."Images/wallpapers" = {
    source = ../../../wallpapers;
    recursive = true;
  };
}
