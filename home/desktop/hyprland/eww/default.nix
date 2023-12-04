{ inputs, config, pkgs, ... }:

{
  home.packages = with pkgs; [
    eww-wayland
    bash
    jq
    socat
    coreutils
  ];

  xdg.configFile.eww = {
    source = ./config;
    recursive = true;
  };
}
