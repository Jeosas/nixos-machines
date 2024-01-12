{ config, pkgs, lib, ... }:

{
  imports = [ ../../modules/home-manager/theme.nix ];

  home.packages = with pkgs; [
    # Fonts
    mplus-outline-fonts.githubRelease # normal + cjk font
    openmoji-color # emoji
    (nerdfonts.override { fonts = [ "MPlus" ]; }) # nerdfonts

    # Cursor
    nordzy-cursor-theme
  ];

  fonts.fontconfig.enable = true;

  theme = {
    colors = {
      color0 = "#3b4252"; # nord1
      color1 = "#bf616a"; # nord11
      color2 = "#a3be8c"; # nord14
      color3 = "#ebcb8b"; # nord13
      color4 = "#81a1c1"; # nord9
      color5 = "#b48ead"; # nord15
      color6 = "#88c0d0"; # nord8
      color7 = "#eceff4"; # nord5
      color8 = "#4c566a"; # nord3
      color9 = "#bf616a"; # nord11
      color10 = "#a3be8c"; # nord14
      color11 = "#ebcb8b"; # nord13
      color12 = "#81a1c1"; # nord9
      color13 = "#b48ead"; # nord15
      color14 = "#8fbcbb"; # nord7
      color15 = "#eceff4"; # nord6
      background = "#2e3440"; # nord0
      foreground = "#d8dee9"; # nord4
      cursor = "#d8dee9"; # nord4
    };

    fonts = {
      sans = "M+1Code Nerd Font";
      mono = "M+1Code Nerd Font Mono";
    };

  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.nordzy-cursor-theme;
    name = "Nordzy-cursors";
    size = 24;
  };

  gtk = {
    enable = true;
    font = {
      name = config.theme.fonts.sans;
      size = 11;
    };
  };
}
