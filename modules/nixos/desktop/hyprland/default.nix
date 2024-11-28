{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace}; let
  brightnessctl = with pkgs;
    writeShellScript "brightnessctl"
    /*
    bash
    */
    ''
      #!${bash}/bin/bash

      notify () {
        brightness="$(light | cut -d'.' -f1)"
        icon="${config.${namespace}.theme.gtk.icon.package}/notification-display-brightness-full.svg"
        dunstify -a "brightness" -u low -t 800 -i $icon -h string:x-dunst-stack-tag:mybrightness \
          "Brightness [$brightness%]" -h int:value:$brightness
      }

      case $1 in
        up) light -A 10 && notify;;
        down) light -U 10 && notify;;
      esac
    '';

  volumectl = with pkgs;
    writeShellScript "volume"
    /*
    bash
    */
    ''
      #!${bash}/bin/bash

      notify () {
        if [[ "$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')" == "yes" ]]; then
          icon="${config.${namespace}.theme.gtk.icon.package}/notification-audio-volume-muted.svg"
          dunstify -a "volume" -u low -t 800 -i $icon -h string:x-dunst-stack-tag:myvolume "Muted"
        else
          volume="$(pactl get-sink-volume @DEFAULT_SINK@ | head -1 | awk '{print $5}' | sed 's/%//g')"
          icon="${config.${namespace}.theme.gtk.icon.package}/notification-audio-volume-high.svg"
          dunstify -a "volume" -u low -t 800 -i $icon -h string:x-dunst-stack-tag:myvolume \
            "Volume [$volume%]" -h int:value:$volume
        fi
      }

      case $1 in
        mute) pactl set-sink-mute @DEFAULT_SINK@ toggle && notify;;
        up)
          pactl set-sink-mute @DEFAULT_SINK@ off && \
          pactl set-sink-volume @DEFAULT_SINK@ +2% && \
          notify
          ;;
        down)
          pactl set-sink-mute @DEFAULT_SINK@ off && \
          pactl set-sink-volume @DEFAULT_SINK@ -2% && \
          notify
          ;;
      esac
    '';

  launch_bar = with pkgs;
    writeShellScript "launch_bar"
    /*
    bash
    */
    ''
      #!${bash}/bin/bash

      ${killall}/bin/killall waybar
      ${killall}/bin/killall .waybar-wrapped

      waybar &
    '';

  cfg = config.${namespace}.desktop.hyprland;

  configOptions = {
    options = with types; {
      layout = mkOpt (enum ["master" "dwindle"]) "dwindle" "Tiling layout to use.";
    };
  };
in {
  options.${namespace}.desktop.hyprland = with types; {
    enable = mkEnableOption "Hyprland custom";
    enableZshLaunchOnLogin = mkOpt bool false "Add startup hooks to zsh .profile.";
    config = mkOpt (submodule configOptions) {} "Hyprland config options.";
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    ${namespace} = {
      desktop.addons = {
        dunst = enabled;
        waybar = enabled;
        wofi = enabled;
      };
    };

    home-manager.users.${config.${namespace}.user.name} = {
      home =
        {
          packages = with pkgs; [wl-clipboard];
        }
        // optionalAttrs config.${namespace}.hardware.graphics.nvidia.enable {
          sessionVariables = {
            # hyprland nvidia fix
            LIBVA_DRIVER_NAME = "nvidia";
            XDG_SESSION_TYPE = "wayland";
            GBM_BACKEND = "nvidia-drm";
            __GLX_VENDOR_LIBRARY_NAME = "nvidia";
          };
        };

      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        systemd.enable = false;

        extraConfig = with config.${namespace}.theme.colors; let
          inherit (lib) removePrefix;
        in ''
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
            layout = ${cfg.config.layout}
            allow_tearing = false
          }

          cursor {
            inactive_timeout = 6
            no_warps = true
            enable_hyprcursor = false
            no_hardware_cursors = 0
            allow_dumb_copy = true
          }

          decoration {
            rounding = 6

            blur {
              enabled = false
            }
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
          bind = SUPER, d, exec, wofi --show drun
          bind = SUPER_SHIFT, Return, exec, firefox
          bind = SUPER, Return, exec, alacritty

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
                bind = SUPER_SHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)}
              ''
            )
            10)}
          bind = SUPER_CTRL_SHIFT, h, movecurrentworkspacetomonitor, l
          bind = SUPER_CTRL_SHIFT, l, movecurrentworkspacetomonitor, r
          bind = SUPER_CTRL_SHIFT, k, movecurrentworkspacetomonitor, u
          bind = SUPER_CTRL_SHIFT, j, movecurrentworkspacetomonitor, d

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
          bindel =, XF86MonBrightnessUp, exec, ${brightnessctl} up
          bindel =, XF86MonBrightnessDown, exec, ${brightnessctl} down
          bindel =, XF86AudioRaiseVolume, exec, ${volumectl} up
          bindel =, XF86AudioLowerVolume, exec, ${volumectl} down
          bindl =, XF86AudioMute, exec,  ${volumectl} mute
          bindl =, XF86AudioMicMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle
          bindl =, XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause
          bindl =, XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl play-pause
          bindl =, XF86AudioStop, exec, ${pkgs.playerctl}/bin/playerctl stop
          bindl =, XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next
          bindl =, XF86AudioPrevious, exec, ${pkgs.playerctl}/bin/playerctl previous
          bind =, Print, exec, ${pkgs.hyprshot}/bin/hyprshot -m output
          bind = SHIFT, Print, exec, ${pkgs.hyprshot}/bin/hyprshot -m region

          # system
          # bind = SUPER_SHIFT, q, exec, POWERMENU
          # bind = SUPER_SHIFT, d, exec, LOCKSCREEN

          # Addons startup
          exec-once=dunst &
          exec=${launch_bar}
        '';
      };

      # Start on login
      programs.zsh = {
        profileExtra =
          /*
          bash
          */
          ''
            if [ -z "$DISPLAY" -a $XDG_VTNR -eq 1 ]; then
              Hyprland
            fi
          '';
      };
    };
  };
}
