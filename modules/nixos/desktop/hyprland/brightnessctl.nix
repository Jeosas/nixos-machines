{
  lib,
  pkgs,
  iconPath,
  ...
}:
let
  inherit (pkgs) writeShellApplication;

  brightnessctl = writeShellApplication {
    name = "brightnessctl";
    runtimeInputs = with pkgs; [
      dunst
      light
    ];

    text =
      # bash
      ''
        notify () {
          brightness="$(light | cut -d'.' -f1)"
          icon="${iconPath}/notification-display-brightness-full.svg"
          dunstify -a "brightness" -u low -t 800 -i $icon -h string:x-dunst-stack-tag:mybrightness \
            "Brightness [$brightness%]" -h int:value:"$brightness"
        }

        case $1 in
          up) light -A 10 && notify;;
          down) light -U 10 && notify;;
        esac
      '';
  };
in
brightnessctl
