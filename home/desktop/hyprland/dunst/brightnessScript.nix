{ pkgs }:

with pkgs;
writeShellScript "brightness" /* bash */ ''
  #!${pkgs.bash}/bin/bash

  notify () {
      brightness="$(light | cut -d'.' -f1)"

      icon="/usr/share/icons/Papirus/48x48/status/notification-display-brightness-low.svg"
      if [[ $brightness -gt 25 ]]; then
          icon="/usr/share/icons/Papirus/48x48/status/notification-display-brightness-medium.svg"
      fi
      if [[ $brightness -gt 50 ]]; then
          icon="/usr/share/icons/Papirus/48x48/status/notification-display-brightness-high.svg"
      fi
      if [[ $brightness -gt 75 ]]; then
          icon="/usr/share/icons/Papirus/48x48/status/notification-display-brightness-full.svg"
      fi

      if [[ $brightness -gt 100 ]]; then
          bar_brightness=100
      else
          bar_brightness=$brightness
      fi

      bar=$(seq -s "─" $(($bar_brightness/4)) | sed 's/[0-9]//g')

      ${dunst}/bin/dunstify -a "brightness" -u low -t 800 -i $icon -h string:x-dunst-stack-tag:mybrightness "$brightness $bar"
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
