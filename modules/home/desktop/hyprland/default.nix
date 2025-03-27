{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (builtins) concatLists genList toString;
  inherit (lib)
    mkIf
    mkEnableOption
    mkMerge
    removePrefix
    ;
  inherit (lib.${namespace}) mkOpt enabled;

  cfg = config.${namespace}.desktop.hyprland;

  iconCfg = config.${namespace}.theme.icon;
  iconPath = "${iconCfg.package}/share/icons/${iconCfg.name}/status/scalable";

  configOptions = {
    options = with lib.types; {
      monitors = mkOpt (listOf str) [ ] "List of monitor settings.";
      exec = mkOpt (listOf str) [ ] "List of process to run on load.";
      exec-once = mkOpt (listOf str) [ ] "List process to run at startup.";
      extraConfig = mkOpt attrs { } "Extra configuration.";
    };
  };
in
{
  options.${namespace}.desktop.hyprland = with lib.types; {
    enable = mkEnableOption "Hyprland custom";
    config = mkOpt (submodule configOptions) { } "Hyprland config options.";
  };

  config = mkIf cfg.enable {
    ${namespace} = {
      desktop.addons = {
        dunst = enabled;
        hyprlock = enabled;
        hyprpaper = enabled;
        waybar = enabled;
        wofi = enabled;
      };
    };

    home = {
      packages = with pkgs; [
        wl-clipboard
        playerctl
        hyprshot

        (callPackage ./brightnessctl.nix { inherit iconPath; })
        (callPackage ./volumectl.nix { inherit iconPath; })
      ];
    };

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd.enable = false;

      settings = mkMerge [
        {
          inherit (cfg.config) exec;
          inherit (cfg.config) exec-once;

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
            allow_dumb_copy = true;
          };

          misc = {
            disable_autoreload = true;
          };

          decoration = {
            rounding = 6;

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

          monitor = cfg.config.monitors;
        }
        cfg.config.extraConfig
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
}
