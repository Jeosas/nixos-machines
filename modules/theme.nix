{
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) listToAttrs;
  inherit (lib.${namespace}) mkOpt mkColorOpt;

  defaultColors = rec {
    background = color0;
    foreground = color5;
    cursor = color5;

    color0 = "#2e3440"; # black
    color1 = "#3b4252"; # bblack
    color2 = "#434c5e"; # bbblack
    color3 = "#4c566a"; # bbbblack
    color4 = "#d8dee9"; # white
    color5 = "#e5e9f0"; # bwhite
    color6 = "#eceff4"; # bbwhite
    color7 = "#8fbcbb"; # bgreen
    color8 = "#bf616a"; # red
    color9 = "#d08770"; # orange
    color10 = "#ebcb8b"; # yellow
    color11 = "#a3be8c"; # green
    color12 = "#88c0d0"; # cyan
    color13 = "#81a1c1"; # bblue
    color14 = "#b48ead"; # magenta
    color15 = "#5e81ac"; # blue
  };
in
{
  options.${namespace}.theme = with lib.types; {
    wallpaper = mkOpt path ../assets/alberta.jpg "Wallpaper";
    colors = listToAttrs (
      map
        (
          key:
          mkColorOpt {
            name = key;
            default = defaultColors.${key};
          }
        )
        [
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
        ]
    );
    borderRadius = mkOpt int 6 "The border radius used across the theme.";
    fonts = {
      sans = {
        name = mkOpt str "M+1Code Nerd Font" "Default sans font";
        package = mkOpt package pkgs.nerd-fonts."m+" "sans font package.";
      };
      mono = {
        name = mkOpt str "Hack Nerd Font Mono" "Default monospace font";
        package = mkOpt package pkgs.nerd-fonts.hack "mono font package";
      };
      emoji = {
        name = mkOpt str "Noto Color Emoji" "Default emoji font";
        package = mkOpt package pkgs.noto-fonts-emoji "emoji font package";
      };
    };
    cursor = {
      name = mkOpt str "Nordzy-cursors" "The name of the cursor theme to apply.";
      hypr-name = mkOpt str "Nordzy-hyprcursors" "The name of the hyprcursor theme to apply.";
      package = mkOpt package pkgs.${namespace}.nordzy-cursors "The package to use for the cursor theme.";
    };
    theme = {
      name = mkOpt str "Nordic-darker" "The name of the GTK theme to apply.";
      package = mkOpt package pkgs.nordic "The package to use for the theme.";
    };
    icon = {
      name = mkOpt str "Nordzy-dark" "The name of the icon theme to apply.";
      package = mkOpt package pkgs.nordzy-icon-theme "The package to use for the icon theme.";
    };
  };
}
