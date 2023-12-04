{ config, pkgs, lib, ... }:

{
  imports = [
    ../../common/theme.nix
    ./i3
    (import ./polybar.nix { })
  ];

  xsession.enable = true;

  home.packages = with pkgs; [
    xorg.xorgserver.out
    xorg.xinit
    xorg.xrandr
  ];

  home.pointerCursor = {
    package = pkgs.nordzy-cursor-theme;
    name = "Nordzy-cursors";
    size = 36;
    x11.enable = true;
  };

  xresources.properties = {
    "*.color0" = config.colors.color0;
    "*.color1" = config.colors.color1;
    "*.color2" = config.colors.color2;
    "*.color3" = config.colors.color3;
    "*.color4" = config.colors.color4;
    "*.color5" = config.colors.color5;
    "*.color6" = config.colors.color6;
    "*.color7" = config.colors.color7;
    "*.color8" = config.colors.color8;
    "*.color9" = config.colors.color9;
    "*.color10" = config.colors.color10;
    "*.color11" = config.colors.color11;
    "*.color12" = config.colors.color12;
    "*.color13" = config.colors.color13;
    "*.color14" = config.colors.color14;
    "*.color15" = config.colors.color15;

    "*.foreground" = config.colors.foreground;
    "*.background" = config.colors.background;
    "*.cursorColor" = config.colors.cursor;
    "*fading" = 35;
    "*fadingColor" = config.colors.color8;
  };

  home.file.".xinitrc" = {
    text = ''
      ${pkgs.xorg.xrdb} -merge ~/.Xresource
      exec i3
    '';
  };

  # Start x
  programs.zsh = {
    profileExtra = /* bash */ ''
      if [ -z "$DISPLAY" -a $XDG_VTNR -eq 1 ]; then
        startx
      fi
    '';
  };
}
