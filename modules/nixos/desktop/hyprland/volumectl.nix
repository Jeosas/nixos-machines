{
  lib,
  pkgs,
  iconPath,
  ...
}:
let
  inherit (pkgs) writeShellApplication;

  volumectl = writeShellApplication {
    name = "volumectl";
    runtimeInputs = with pkgs; [
      dunst
      wireplumber
    ];

    text =
      # sh
      ''
        notify () {
          volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)

          if [[ "$(echo "$volume" | awk '{print $3}')" == "[MUTED]" ]]; then
            icon="${iconPath}/notification-audio-volume-muted.svg"
            dunstify -a "volume" -u low -t 800 -i $icon -h string:x-dunst-stack-tag:myvolume "Muted"
          else
            icon="${iconPath}/notification-audio-volume-high.svg"
            volume_percent=$(awk '{printf("%d", 100 * $2)}' <<< "$volume")
            dunstify -a "volume" -u low -t 800 -i $icon -h string:x-dunst-stack-tag:myvolume \
              "Volume [$volume_percent%]" -h "int:value:$volume_percent"
          fi
        }

        case $1 in
          mute) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && notify;;
          up)
            wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && \
            wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 2%+ && \
            notify
            ;;
          down)
            wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && \
            wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 2%- && \
            notify
            ;;
        esac
      '';
  };
in
volumectl
