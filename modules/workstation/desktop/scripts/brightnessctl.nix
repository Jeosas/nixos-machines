{
  lib,
  pkgs,
  iconPath,
  ...
}:
let
  inherit (pkgs) writeShellApplication;

  brightnessctl_ = writeShellApplication {
    name = "brightnessctl";
    runtimeInputs = with pkgs; [
      dunst
      brightnessctl
    ];

    text =
      # bash
      ''
        notify () {
          brightness="$(brightnessctl get)"
          icon="${iconPath}/notification-display-brightness-full.svg"
          dunstify -a "brightness" -u low -t 800 -i "$icon" -h string:x-dunst-stack-tag:mybrightness \
            "Brightness [$brightness%]" -h "int:value:$brightness"
        }

        case $1 in
          up) brightnessctl set +10%;;
          down) brightnessctl set 10%-;;
        esac
      '';
  };
in
brightnessctl_
