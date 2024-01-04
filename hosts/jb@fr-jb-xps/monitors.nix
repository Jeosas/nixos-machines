{ config, ... }:

{
  wayland.windowManager.hyprland.extraConfig = ''
    monitor=,1920x1080@60,auto,auto
  '';
}
