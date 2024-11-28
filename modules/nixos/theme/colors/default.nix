{
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  default-colors = {
    background = "#2e3440"; # nord0
    foreground = "#d8dee9"; # nord4
    cursor = "#d8dee9"; # nord4
    color0 = "#3b4252"; # nord1 - black
    color1 = "#bf616a"; # nord11 - red
    color2 = "#a3be8c"; # nord14 - green
    color3 = "#ebcb8b"; # nord13 - yellow
    color4 = "#81a1c1"; # nord9 - blue
    color5 = "#b48ead"; # nord15 - magenta
    color6 = "#88c0d0"; # nord8 - cyan
    color7 = "#eceff4"; # nord5 - white
    color8 = "#4c566a"; # nord3 - bblack
    color9 = "#bf616a"; # nord11 - bred
    color10 = "#a3be8c"; # nord14 - bgreen
    color11 = "#ebcb8b"; # nord13 - byallow
    color12 = "#81a1c1"; # nord9 - bblue
    color13 = "#b48ead"; # nord15 - bmagenta
    color14 = "#8fbcbb"; # nord7 - bcyan
    color15 = "#eceff4"; # nord6 - cwhite
  };

  mkColorOption = name: {
    inherit name;
    value = mkOpt (types.strMatching "#[a-fA-F0-9]{6}") default-colors.${name} "Color for ${name}.";
  };
in {
  options.${namespace}.theme.colors = listToAttrs (map mkColorOption [
    "background"
    "foreground"
    "cursor"
    "color0"
    "color1"
    "color2"
    "color3"
    "color4"
    "color5"
    "color6"
    "color7"
    "color8"
    "color9"
    "color10"
    "color11"
    "color12"
    "color13"
    "color14"
    "color15"
  ]);
}
