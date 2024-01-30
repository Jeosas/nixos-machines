{ config, ... }:


{
  wayland.windowManager.hyprland.extraConfig = ''
    monitor=eDP-1,1920x1080@60,auto,1
    monitor=,preferred,auto,1
  '';
}
