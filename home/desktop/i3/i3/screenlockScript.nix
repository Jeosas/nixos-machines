{ pkgs, colors }:

with pkgs;
writeShellScript "screenlock" /* bash */ ''
  #! ${pkgs.bash}/bin/bash

  # pause notifications
  ${dunst}/bin/dunstctl set-paused true

  # lock screen
  ${i3lock-color}/bin/i3lock \
      --screen 0 \
      -c 1a1a1aff \
      --blur 8 \
      --indicator \
      --inside-color 00000000 \
      --ring-color "${colors.color7}ff" \
      --line-color 00000000 \
      --insidever-color 00000000 \
      --ringver-color "${colors.color4}ff" \
      --insidewrong-color 00000000 \
      --ringwrong-color "${colors.color1}ff" \
      --keyhl-color "${colors.color2}ff" \
      --bshl-color "${colors.color3}ff" \
      --separator-color 00000000 \
      --force-clock \
      --time-str "%H:%M" \
      --time-font "Hack" \
      --time-size 32 \
      --time-color "${colors.color7}ff" \
      --date-str "" \
      --verif-text "" \
      --wrong-text "" \
      --noinput-text "" \
      --modif-color "${colors.color9}ff" \
      --modif-size 16 \
      --nofork

  # unpause notifications
  ${dunst}/bin/dunstctl set-paused false
''


