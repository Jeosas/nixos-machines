{
  config,
  pkgs,
  lib,
  ...
}: let
  hmConfig = config.home-manager.users.${config.jeomod.user};

  launch_bar =
    pkgs.writeShellScript "launch_bar"
    /*
    bash
    */
    ''
      #!${pkgs.bash}/bin/bash

      ${pkgs.killall}/bin/killall waybar
      ${pkgs.killall}/bin/killall .waybar-wrapped

      ${hmConfig.programs.waybar.package}/bin/waybar &
    '';

  bg = "#2e3440";
  bblack = "#4c566a";
  white = "#eceff4";
  grey = "#3b4252";
  green = "#a3be8c";
  red = "#bf616a";
in
  with lib; {
    config = mkIf config.jeomod.desktop.hyprland.enable {
      home-manager.users.${config.jeomod.user} = {
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
            modules-left = ["image#nixos" "custom/separator" "hyprland/workspaces"];
            # modules-center = [ ];
            modules-right = ["cpu" "temperature" "custom/separator" "pulseaudio" "battery" "custom/separator" "clock"];

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
              persistent-workspaces."*" = 10;
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
            clock = {
              format = "{:%H:%M}";
              tooltip = true;
              tooltip-format = "<tt><small>{calendar}</small></tt>";
              calendar = {
                mode = "year";
                mode-mon-col = 3;
                weeks-pos = "right";
                on-scroll = 1;
                on-click-right = "mode";
                format = {
                  months = "<span color='${white}'><b>{}</b></span>";
                  days = "<span color='#ecc6d9'><b>{}</b></span>";
                  weeks = "<span color='#99ffdd'><b>W{}</b></span>";
                  weekdays = "<span color='#ffcc66'><b>{}</b></span>";
                  today = "<span color='${green}'><b><u>{}</u></b></span>";
                };
              };
            };
            battery = {
              states = {
                warning = 30;
                critical = 10;
              };
              format = "{icon} {capacity}%";
              format-warning = "{icon} {capacity}%";
              format-critical = "{icon} {capacity}%";
              format-charging = "󰂄 {capacity}%";
              format-plugged = "󰚥 {capacity}%";
              format-alt = "{icon} {capacity}%";
              format-full = "󰁹 100%";
              format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
            };
            pulseaudio = {
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
              on-click = "${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
              on-click-right = "${pkgs.alacritty}/bin/alacritty -e ${pkgs.ncpamixer}/bin/ncpamixer";
            };
            temperature = {
              thermal-zone = 6; # cpu
              critical-threshold = 80;
              format = " {temperatureC}°C";
              format-critical = " {temperatureC}°C";
              tooltip = false;
            };
            cpu = {
              format = "󰯱 {load}";
            };
          };

          style =
            /*
            css
            */
            ''
              window#waybar {
                background-color: transparent;
              }

              .modules-left, .modules-right, .modules-center {
                font-family: "M+1Code Nerd Font";
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
                font-family: "M+1Code Nerd Font Mono";
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

        wayland.windowManager.hyprland.extraConfig = ''
          exec=${launch_bar}
        '';
      };
    };
  }
