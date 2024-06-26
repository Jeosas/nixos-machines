{pkgs}:
with pkgs; let
  icons = "${nordzy-icon-theme}/share/icons/Nordzy/status/scalable";
in
  writeShellScript "volume"
  /*
  bash
  */
  ''
    notify () {
    	if [[ "$(${pulseaudio}/bin/pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')" == "yes" ]]; then
    		icon="${icons}/notification-audio-volume-muted.svg"
    	  ${dunst}/bin/dunstify -a "volume" -u low -t 800 -i $icon -h string:x-dunst-stack-tag:myvolume "Muted"

    	else
    		volume="$(${pulseaudio}/bin/pactl get-sink-volume @DEFAULT_SINK@ | head -1 | awk '{print $5}' | sed 's/%//g')"
    		icon="${icons}/notification-audio-volume-high.svg"
    	  ${dunst}/bin/dunstify -a "volume" -u low -t 800 -i $icon -h string:x-dunst-stack-tag:myvolume \
          "Volume [$volume%]" -h int:value:$volume
    	fi
    }

    case $1 in
    	mute)
    		${pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle && \
        notify
    		;;
     	up)
     		${pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ off && \
     		${pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +2% && \
     		notify
     		;;
     	down)
     		${pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ off && \
     		${pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -2% && \
     		notify
     		;;
    esac
  ''
