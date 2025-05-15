{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) listToAttrs mkIf mkEnableOption;
  inherit (lib.${namespace}) mkOpt mkColorOpt;

  defaultColors = {
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

  defaultFont =
    {
      "24.11" = pkgs.nerdfonts.override { fonts = [ "MPlus" ]; };
    }
    ."${config.system.nixos.release}" or pkgs.nerd-fonts."m+";

  cfg = config.${namespace}.theme;
in
{
  options.${namespace}.theme = with lib.types; {
    enable = mkEnableOption "theme";
    wallpaper = mkOpt path ../../../assets/wallpaper.jpg "Wallpaper";
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
    fonts = {
      sans = {
        name = mkOpt str "M+1Code Nerd Font" "Default sans font";
        package = mkOpt package defaultFont "sans font package.";
      };
      mono = {
        name = mkOpt str "M+1Code Nerd Font Mono" "Default monospace font";
        package = mkOpt package defaultFont "mono font package";
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

  config = mkIf cfg.enable {
    ${namespace}.home.extraConfig = {
      ${namespace}.theme = {
        enable = true;
        inherit (cfg)
          wallpaper
          colors
          fonts
          cursor
          theme
          icon
          ;
      };
    };
  };
}
