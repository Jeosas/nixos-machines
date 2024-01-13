{ inputs, config, pkgs, lib, ... }:

with pkgs.lib.strings;
let
  volume = import ./dunst/volumeScript.nix { inherit pkgs; };
  brightness = import ./dunst/brightnessScript.nix { inherit pkgs; };
in
{
  imports = [
    inputs.hyprland.homeManagerModules.default

    ../../common/theme.nix
    ./eww
    ./dunst
    ./wofi
  ];

  home.packages = with pkgs; [ wl-clipboard ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = false;

    extraConfig = with config.theme.colors; let
      inherit (lib) removePrefix;
    in
    ''
      input {
        kb_layout = us
        kb_variant = altgr-intl
        kb_model = pc105
        follow_mouse = 0
      }

      general {
        gaps_in = 4
        gaps_out = 8
        border_size = 1
        col.active_border = rgba(${removePrefix "#" color2}ff) rgba(${removePrefix "#" color6}ff) 45deg
        col.inactive_border = rgba(${removePrefix "#" background}cc)
        layout = master
        allow_tearing = false
        cursor_inactive_timeout = 6
        no_cursor_warps = true
      }

      decoration {
        rounding = 6
        blur {
          enabled = true
          size = 3
          passes = 1
        }
        drop_shadow = true
        shadow_range = 4
        shadow_render_power = 3
        col.shadow = rgba(1a1a1aee)
      }

      animations {
        enabled = true
        bezier = myBezier, 0.05, 0.9, 0.1, 1.05
        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 7, default, popin 80%
        animation = border, 1, 10, default
        animation = borderangle, 1, 8, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default
      }

      input {
        follow_mouse = 2
      }

      dwindle {
        pseudotile = true
        force_split = 2
      }

      master {
        mfact = 0.35
        new_on_top = true
        orientation = center
      }

      # apps
      bind = SUPER, d, exec, ${config.programs.wofi.package}/bin/wofi --show drun
      bind = SUPER_SHIFT, Return, exec,${config.programs.firefox.package}/bin/firefox 
      bind = SUPER, Return, exec, ${pkgs.alacritty}/bin/alacritty

      # workspaces
      # binds SUPER + [shift +] {1..10} to [move to] workspace {1..10}
      ${builtins.concatStringsSep "\n" (builtins.genList (
          x: let
            ws = let
              c = (x + 1) / 10;
            in
              builtins.toString (x + 1 - (c * 10));
          in ''
            bind = SUPER, ${ws}, workspace, ${toString (x + 1)}
            bind = SUPER_SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
          ''
        )
        10)}

      # move around
      bind = SUPER, h, movefocus, l
      bind = SUPER, l, movefocus, r
      bind = SUPER, k, movefocus, u
      bind = SUPER, j, movefocus, d
      bind = SUPER_SHIFT, h, swapwindow, l
      bind = SUPER_SHIFT, l, swapwindow, r
      bind = SUPER_SHIFT, k, swapwindow, u
      bind = SUPER_SHIFT, j, swapwindow, d
      bindm = SUPER, mouse:272, movewindow

      # windows
      bind = SUPER_SHIFT, a, killactive
      bind = SUPER, Space, togglefloating, active
      bind = SUPER, f, fullscreen, 1
      bind = SUPER_SHIFT, p, pin, active
      binde = SUPER_CTRL, h, resizeactive, -50 0
      binde = SUPER_CTRL, l, resizeactive, 50 0
      binde = SUPER_CTRL, k, resizeactive, 0 -50
      binde = SUPER_CTRL, j, resizeactive, 0 50

      # media
      bindel =, XF86MonBrightnessUp, exec, ${brightness} up
      bindel =, XF86MonBrightnessDown, exec, ${brightness} down
      bindel =, XF86AudioRaiseVolume, exec, ${volume} up
      bindel =, XF86AudioLowerVolume, exec, ${volume} down
      bindl =, XF86AudioMute, exec,  ${volume} mute
      bindl =, XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause
      bindl =, XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl play-pause
      bindl =, XF86AudioStop, exec, ${pkgs.playerctl}/bin/playerctl stop
      bindl =, XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next
      bindl =, XF86AudioPrevious, exec, ${pkgs.playerctl}/bin/playerctl previous
      bind =, Print, exec, ${pkgs.flameshot}/bin/flameshot screen
      bind = SHIFT, Print, exec, ${pkgs.flameshot}/bin/flameshot gui -s -p ~/Images

      # system
      # bind = SUPER_SHIFT, q, exec, POWERMENU
      # bind = SUPER_SHIFT, d, exec, LOCKSCREEN
    '';
  };

  # xdg.portal = {
  #   config = {
  #     common = {
  #       default = [ "gtk" ];
  #     };
  #   };
  # };

  # Start on login
  programs.zsh = {
    profileExtra =
      if config.targets.genericLinux.enable
      then /* bash */ ''
        if [ -z "$DISPLAY" -a $XDG_VTNR -eq 1 ]; then
          ${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL Hyprland
        fi
      ''
      else /* bash */ ''
        if [ -z "$DISPLAY" -a $XDG_VTNR -eq 1 ]; then
          Hyprland
        fi
      '';
  };
}

