{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkOpt;
  inherit (config.${namespace}.theme) colors;

  bg = colors.background;
  white = colors.color15;
  grey = colors.color0;
  green = colors.color2;
  red = colors.color9;

  cfg = config.${namespace}.desktop.addons.waybar;
in
{
  options.${namespace}.desktop.addons.waybar = with lib.types; {
    enable = mkEnableOption "waybar";
    cpu-temp-zone = mkOpt int 2 "thermal zone for cpu temperature.";
  };

  config = mkIf cfg.enable {
    ${namespace}.desktop.hyprland.config.exec = [ "launchbar" ];

    home.packages = with pkgs; [ (callPackage ./launchbar.nix { }) ];

    programs.waybar = {
      enable = true;
      settings.main = {
        # Bar setting
        position = "top";
        layer = "top";
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
          "custom/kernel"
        ];
        # modules-center = [ ];
        modules-right = [
          "tray"
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

        "custom/kernel" = {
          format = "  {}";
          interval = 3600;
          exec = "uname -ro";
          tooltip = false;
        };

        clock = {
          format = "{:%H:%M}";
          tooltip = true;
          tooltip-format = "{calendar}";
          calendar = {
            format = {
              today = "<span color='${green}'><b>{}</b></span>";
            };
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
          on-click-right = "${lib.getExe pkgs.kitty} -e ${lib.getExe pkgs.ncpamixer}";
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
            border-radius: 6px;
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
            font-family: "${config.${namespace}.theme.fonts.mono.name}";
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
        '';
    };
  };
}
