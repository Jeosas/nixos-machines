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

    # Wayland support for Electron/Chromium apps
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # https://github.com/NixOS/nixpkgs/issues/464473
    i18n.inputMethod = {
      enable = true;
      type = "ibus";
    };

    home-manager.users.${config.${namespace}.user.name} = {
      home = {
        packages = with pkgs; [
          wl-clipboard
          hyprshot
        ];
      };

      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        systemd.enable = false;

        configType = "hyprlang";
        settings =
          let
            ipc_call = "noctalia-shell ipc call";
          in
          mkMerge [
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
                "col.active_border" =
                  "rgba(${removePrefix "#" color11}ff) rgba(${removePrefix "#" color12}ff) 45deg";
                "col.inactive_border" = "rgba(${removePrefix "#" background}cc)";
                layout = "scrolling";
                allow_tearing = false;
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

              workspace = [
                "1, defaultName:一"
                "2, defaultName:二"
                "3, defaultName:三"
                "4, defaultName:四"
                "5, defaultName:五"
                "6, defaultName:六"
                "7, defaultName:七"
                "8, defaultName:八"
                "9, defaultName:九"
                "10, defaultName:十"
              ];

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

              bind = [
                # apps
                "SUPER, d, exec, ${ipc_call} launcher toggle"
                "SUPER_SHIFT, Return, exec, mullvad-browser"
                "SUPER_CTRL, Return, exec, firefox"
                "SUPER, Return, exec, ghostty"
                "SUPER, c, exec, ${ipc_call} controlCenter toggle"
                "SUPER, v, exec, ${ipc_call} volume togglePanel"
                "SUPER, b, exec, ${ipc_call} bluetooth togglePanel"
                "SUPER, n, exec, ${ipc_call} network togglePanel"

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
                "SUPER_SHIFT, d, exec, ${ipc_call} lockScreen lock"
                # power menu
                "SUPER_SHIFT, q, exec, ${ipc_call} sessionMenu toggle"
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
                ", XF86AudioMute, exec, ${ipc_call} volume muteOutput"
                ", XF86AudioMicMute, exec, ${ipc_call} volume muteInput"

                # media
                ", XF86AudioPlay, exec, ${ipc_call} media playPause"
                ", XF86AudioPause, exec, ${ipc_call} media pause"
                ", XF86AudioNext, exec, ${ipc_call} media next"
                ", XF86AudioPrev, exec, ${ipc_call} media previous"
              ];

              bindle = [
                # brightness
                ", XF86MonBrightnessUp, exec, ${ipc_call} brightness increase"
                ", XF86MonBrightnessDown, exec, ${ipc_call} brightness decrease"

                # volume
                ", XF86AudioRaiseVolume, exec, ${ipc_call} volume increase"
                ", XF86AudioLowerVolume, exec, ${ipc_call} volume decrease"
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
    };
  };
}
