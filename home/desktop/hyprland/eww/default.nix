{ inputs, config, pkgs, ... }:

let
  launch_bar = pkgs.writeShellScript "launch_bar" /* bash */ ''
    #!${pkgs.bash}/bin/bash

    eww=${pkgs.eww-wayland}/bin/eww

    ## Start/Reload eww daemon
    $eww daemon --restart
    sleep 1

    $eww close-all
    $eww open bar

  '';
in
{
  home.packages = with pkgs; [
    eww-wayland
    bash
    jq
    socat
    coreutils
    playerctl
    zscroll
  ];

  xdg.configFile.eww = {
    source = ./config;
    recursive = true;
  };

  wayland.windowManager.hyprland.extraConfig = ''
    exec=${launch_bar}
  '';
}
