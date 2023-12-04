{ pkgs }:

with pkgs;
writeShellScript "volume" /* bash */ ''
  #! ${pkgs.bash}/bin/bash

  notify () {
  	if [[ "$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')" == "yes" ]]; then
  		icon="/usr/share/icons/Papirus/48x48/status/notification-audio-volume-muted.svg"
  	  ${dunst}/bin/dunstify -a "volume" -u low -t 800 -i $icon -h string:x-dunst-stack-tag:myvolume "Muted"

  	else
  		volume="$(pactl get-sink-volume @DEFAULT_SINK@ | head -1 | awk '{print $5}' | sed 's/%//g')"

  		icon="/usr/share/icons/Papirus/48x48/status/notification-audio-volume-low.svg"
  		if [[ $volume -gt 35 ]]; then
  			icon="/usr/share/icons/Papirus/48x48/status/notification-audio-volume-medium.svg"
  		fi
  		if [[ $volume -gt 65 ]]; then
  			icon="/usr/share/icons/Papirus/48x48/status/notification-audio-volume-high.svg"
  		fi

  		if [[ $volume -gt 100 ]]; then
  			bar_volume=100
  		else
  			bar_volume=$volume
  		fi

  		bar=$(seq -s "─" $(($bar_volume/4)) | sed 's/[0-9]//g')

  	  ${dunst}/bin/dunstify -a "volume" -u low -t 800 -i $icon -h string:x-dunst-stack-tag:myvolume "$volume $bar"
  	fi
  }

  case $1 in
  	mute)
  		pactl set-sink-mute @DEFAULT_SINK@ toggle && \
      notify
  		;;
   	up)
   		pactl set-sink-mute @DEFAULT_SINK@ off && \
   		pactl set-sink-volume @DEFAULT_SINK@ +2% && \
   		notify
   		;;
   	down)
   		pactl set-sink-mute @DEFAULT_SINK@ off && \
   		pactl set-sink-volume @DEFAULT_SINK@ -2% && \
   		notify
   		;;
  esac
''
