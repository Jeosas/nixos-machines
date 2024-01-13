{ pkgs }:

with pkgs;
let
  icons = "${nordzy-icon-theme}/share/icons/Nordzy/status/scalable";
in
writeShellScript "brightness" /* bash */ ''
  #!${pkgs.bash}/bin/bash

  notify () {
      brightness="$(light | cut -d'.' -f1)"
      icon="${icons}/notification-display-brightness-full.svg"
      ${dunst}/bin/dunstify -a "brightness" -u low -t 800 -i $icon -h string:x-dunst-stack-tag:mybrightness \
        "Brightness [$brightness%]" -h int:value:$brightness 
  }

  case $1 in
      up)
          ${light}/bin/light -A 10
          notify
          ;;
      down)
          ${light}/bin/light -U 10
          notify
          ;;
  esac
''
