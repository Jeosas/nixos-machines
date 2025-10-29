{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (builtins) toString;
  inherit (lib.${namespace}) mkOpt;
  inherit (config.${namespace}.theme) colors;

  bg = colors.background;
  white = colors.color5;
  grey = colors.color1;
  green = colors.color11;
  red = colors.color8;
  yellow = colors.color10;
  cyan = colors.color12;

  cfg = config.${namespace}.workstation.desktop.waybar;
in
{
  options.${namespace}.workstation.desktop.waybar = with lib.types; {
    cpu-temp-zone = mkOpt int 2 "thermal zone for cpu temperature.";
  };

  config = {
    ${namespace}.workstation.desktop.hyprland.exec = [ "launchbar" ];

    home-manager.users.${config.${namespace}.user.name} = {

      home.packages =
        with pkgs;
        let
          launchbar = callPackage ./scripts/launchbar.nix { };
        in
        [
          jq
          launchbar
        ];

      programs.waybar = {
        enable = true;
        settings.main = {
          # Bar setting
          position = "top";
          layer = "bottom";
          height = 36;
          margin-top = 8;
          margin-left = 8;
          margin-right = 8;
          spacing = 12;
          # output = [
          #   "eDP-1"
          #   "HDMI-A-1"
          # ];
          modules-left = [
            "image#nixos"
            "custom/separator"
            "hyprland/workspaces"
            "custom/separator"
            "custom/version"
          ];
          # modules-center = [ ];
          modules-right = [
            "privacy"
            "tray"
            "custom/separator"
            "custom/pomodoro"
            "custom/separator"
            "load"
            "memory"
            "temperature"
            "custom/separator"
            "network"
            "wireplumber"
            "battery"
            "custom/separator"
            "clock"
          ];

          # Modules
          "custom/separator" = {
            format = "|";
            interval = "once";
            tooltip = false;
          };

          "image#nixos" = {
            path = ./nix-snowflake.svg;
            size = 18;
          };

          "hyprland/workspaces" = {
            active-only = false;
            all-outputs = false;
            persistent-workspaces = {
              "*" = [
                1
                2
                3
                4
                5
                6
                7
                8
                9
                10
              ];
            };
            sort-by = "id";
            format = "{icon}";
            format-icons = {
              "1" = "一";
              "2" = "二";
              "3" = "三";
              "4" = "四";
              "5" = "五";
              "6" = "六";
              "7" = "七";
              "8" = "八";
              "9" = "九";
              "10" = "十";
            };
          };

          "custom/version" = {
            format = "  {}";
            interval = 3600;
            exec = "nixos-version";
            tooltip = false;
          };

          privacy =
            let
              icon-size = 14;
            in
            {
              inherit icon-size;
              icon-spacing = 4;
              transition-duration = 250;
              modules = [
                {
                  type = "screenshare";
                  tooltip-icon-size = icon-size;
                }
                {
                  type = "audio-in";
                  tooltip-icon-size = icon-size;
                }
              ];
            };

          clock = {
            format = "{:%H:%M}";
            tooltip = true;
            tooltip-format = "{calendar}";
            calendar = {
              mode = "month";
              format = {
                weekdays = "<span color='${cyan}'><b>{}</b></span>";
                today = "<span color='${green}'><b><u>{}</u></b></span>";
              };
            };
            actions = {
              on-scroll-up = "shift_down";
              on-scroll-down = "shift_up";
              on-click-right = "shift_reset";
            };
          };

          battery = {
            states = {
              warning = 30;
              critical = 10;
            };
            format = "{icon} {capacity}%";
            format-charging = "󰂄 {capacity}%";
            format-plugged = "󰚥 {capacity}%";
            format-full = "󰁹 100%";
            format-icons = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
            interval = 5;
          };

          wireplumber = {
            format = "{icon} {volume}%";
            format-muted = "󰝟 {volume}%";
            format-icons = {
              default = "󰕾";
              speaker = "󰕾";
              headphone = "󰋋";
              headset = "󰋎";
              hands-free = "󰥰";
              hdmi = "󰍹";
              phone = "󰏲";
              portable = "󰏲";
              car = "󰄋";
            };
            on-click = "volumectl mute";
            on-click-right = "${lib.getExe pkgs.ghostty} -e ${lib.getExe pkgs.wiremix}";
          };

          network = {
            format-wifi = "{icon}";
            format-icons = [
              "󰤯 "
              "󰤟 "
              "󰤢 "
              "󰤥 "
              "󰤨 "
            ];
            format-ethernet = "󰈁";
            format-disconnected = "󰖪 ";
            tooltip-format-wifi = ''
              {icon} {essid}
              ⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}'';
            tooltip-format-ethernet = ''
              󰈁 {ifname}
              ⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}'';
            tooltip-format-disconnected = "Disconnected";
            interval = 5;
            nospacing = 1;
          };

          temperature = {
            thermal-zone = cfg.cpu-temp-zone; # cpu
            critical-threshold = 80;
            format = " {temperatureC}°C";
            format-critical = " {temperatureC}°C";
            tooltip = false;
            interval = 5;
          };

          memory = {
            format = "󰰏 {percentage}%";
            interval = 5;
          };

          load = {
            format = "󰯱 {load1}";
            interval = 5;
          };

          tray = {
            spacing = 10;
          };

          "custom/pomodoro" =
            let
              pomodoro-cli = "${pkgs.${namespace}.pomodoro-cli}/bin/pomodoro-cli";
            in
            {
              format = " {}";
              exec = "${pomodoro-cli} status --format json --time-format segmented";
              return-type = "json";
              on-click = "${pomodoro-cli} start --add 5m --notify";
              on-click-middle = "${pomodoro-cli} pause";
              on-click-right = "${pomodoro-cli} stop";
              interval = 1;
            };
        };

        style =
          # css
          ''
            window#waybar {
              background-color: transparent;
            }

            .modules-left, .modules-right, .modules-center {
              font-family: "${config.${namespace}.theme.fonts.sans.name}";
              font-size: 14px;
              font-weight: 500;
              padding-left: 14px;
              padding-right: 14px;
              background-color: ${bg};
              color: ${white};
              border-radius: ${toString config.${namespace}.theme.borderRadius}px;
            }

            .modules-center {
              /* TODO: remove me when some modules are added */
              background-color: transparent;
            }

            tooltip {
              background: ${bg};
              border-radius: 6px;
              border: none;
            }
            tooltip label {
              color: ${white};
            }

            #custom-separator {
              color: ${grey};
              /* margin: 0 5px; */
            }

            #workspaces button {
              color: ${white};
              font-size: 18px;
              font-weight: 500;
            }
            #workspaces button:hover {
              background-color: inherit;
            }
            #workspaces button.empty {
              color: ${grey};
            }
            #workspaces button.visible {
              color: ${green};
            }

            #clock {
              font-family: "${config.${namespace}.theme.fonts.sans.name}";
              font-size: 18px;
              letter-spacing: 2px;
            }

            #battery.warning {
              color: ${red};
            }
            #battery.critical {
              color: ${red};
            }

            #temperature.critical {
              color: ${red};
            }

            #custom-hl-fullscreen {
              color: ${red};
            }

            #custom-pomodoro.running {
              color: ${green};
            }
            #custom-pomodoro.paused {
              color: ${yellow};
            }
            #custom-pomodoro.finished {
              color: ${white};
            }

            #privacy-item {
              color: ${red};
            }
          '';
      };
    };
  };
}
