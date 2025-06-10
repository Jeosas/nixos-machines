{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (builtins) concatLists genList toString;
  inherit (lib) mkMerge removePrefix;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.workstation.desktop.hyprland;

in
{
  options.${namespace}.workstation.desktop.hyprland = with lib.types; {
    monitors = mkOpt (listOf str) [ ] "List of monitor settings.";
    exec = mkOpt (listOf str) [ ] "List of process to run on load.";
    exec-once = mkOpt (listOf str) [ ] "List process to run at startup.";
  };

  config = {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    home-manager.users.${config.${namespace}.user.name} = {
      home = {
        packages =
          with pkgs;
          let
            iconCfg = config.${namespace}.theme.icon;
            iconPath = "${iconCfg.package}/share/icons/${iconCfg.name}/status/scalable";

            brightnessctl = callPackage ./scripts/brightnessctl.nix { inherit iconPath; };
            volumectl = callPackage ./scripts/volumectl.nix { inherit iconPath; };
          in
          [
            wl-clipboard
            playerctl
            hyprshot

            brightnessctl
            volumectl
          ];
      };

      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        systemd.enable = false;

        settings = mkMerge [
          {
            inherit (cfg) exec;
            inherit (cfg) exec-once;

            misc = {
              disable_hyprland_logo = true;
              disable_splash_rendering = true;
            };

            general = with config.${namespace}.theme.colors; {
              gaps_in = 4;
              gaps_out = 8;
              border_size = 1;
              "col.active_border" = "rgba(${removePrefix "#" color2}ff) rgba(${removePrefix "#" color6}ff) 45deg";
              "col.inactive_border" = "rgba(${removePrefix "#" background}cc)";
              layout = "dwindle";
              allow_tearing = false;
            };

            dwindle = {
              force_split = 2;
              split_width_multiplier = 1.65;
            };

            input = {
              kb_layout = "us";
              kb_variant = "altgr-intl";
              kb_model = "pc105";
              follow_mouse = 2;
            };

            cursor = {
              enable_hyprcursor = true;
              inactive_timeout = 6;
              warp_on_change_workspace = 1;
              no_hardware_cursors = 0;
              use_cpu_buffer = 1;
            };

            misc = {
              disable_autoreload = true;
            };

            decoration = {
              rounding = config.${namespace}.theme.borderRadius;

              blur = {
                enabled = false;
              };
            };

            animations = {
              enabled = true;
              bezier = [ "overshot, 0.05, 0.9, 0.1, 1.05" ];
              animation = [
                "border, 1, 2, default"
                "fade, 1, 3, default"
                "windows, 1, 3, overshot, popin 80%"
                "workspaces, 1, 2, default, slide"
              ];
            };

            bind =
              [
                # apps
                "SUPER, d, exec, wofi --show drun"
                "SUPER_SHIFT, Return, exec, mullvad-browser"
                "SUPER_CTRL, Return, exec, firefox"
                "SUPER, Return, exec, kitty"
                "SUPER, c, exec, kitty -e nmtui"
                "SUPER, v, exec, kitty -e ncpamixer"
                "SUPER, b, exec, kitty -e bluetuith"

                # workspace move
                "SUPER_CTRL_SHIFT, h, movecurrentworkspacetomonitor, l"
                "SUPER_CTRL_SHIFT, l, movecurrentworkspacetomonitor, r"
                "SUPER_CTRL_SHIFT, k, movecurrentworkspacetomonitor, u"
                "SUPER_CTRL_SHIFT, j, movecurrentworkspacetomonitor, d"

                # window focus move
                "SUPER, h, movefocus, l"
                "SUPER, l, movefocus, r"
                "SUPER, k, movefocus, u"
                "SUPER, j, movefocus, d"

                # window move
                "SUPER_SHIFT, h, movewindow, l"
                "SUPER_SHIFT, l, movewindow, r"
                "SUPER_SHIFT, k, movewindow, u"
                "SUPER_SHIFT, j, movewindow, d"

                # window action
                "SUPER_SHIFT, a, killactive"
                "SUPER, Space, togglefloating, active"
                "SUPER, f, fullscreen, 1"
                "SUPER_SHIFT, p, pin, active"

                # screen capture
                ", Print, exec, hyprshot -m output"
                "SHIFT, Print, exec, hyprshot -m region"

                # screen lock
                "SUPER_SHIFT, d, exec, hyprlock"
              ]
              ++ (concatLists (
                genList (
                  x:
                  let
                    ws =
                      let
                        c = (x + 1) / 10;
                      in
                      toString (x + 1 - (c * 10));
                  in
                  [
                    # change workspace [0-9]
                    "SUPER, ${ws}, workspace, ${toString (x + 1)}"
                    "SUPER_SHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
                  ]
                ) 10
              ));

            binde = [
              # window resize
              "SUPER_CTRL, h, resizeactive, -50 0"
              "SUPER_CTRL, l, resizeactive, 50 0"
              "SUPER_CTRL, k, resizeactive, 0 -50"
              "SUPER_CTRL, j, resizeactive, 0 50"
            ];

            bindl = [
              # volume
              ", XF86AudioMute, exec,  volumectl mute"
              # mic
              ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

              # media
              ", XF86AudioPlay, exec, playerctl play-pause"
              ", XF86AudioPause, exec, playerctl play-pause"
              ", XF86AudioStop, exec, playerctl stop"
              ", XF86AudioNext, exec, playerctl next"
              ", XF86AudioPrev, exec, playerctl previous"
            ];

            bindle = [
              # brightness
              ", XF86MonBrightnessUp, exec, brightnessctl up"
              ", XF86MonBrightnessDown, exec, brightnessctl down"

              # volume
              ", XF86AudioRaiseVolume, exec, volumectl up"
              ", XF86AudioLowerVolume, exec, volumectl down"
            ];

            bindm = [
              # window move
              "SUPER, mouse:272, movewindow"
            ];

            monitor = cfg.monitors;

            ecosystem = {
              no_update_news = true;
              no_donation_nag = true;
            };
          }
        ];
      };

      # Start on login
      programs.zsh = {
        profileExtra =
          # bash
          ''
            if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
              Hyprland
            fi
          '';
      };
    };
  };
}
