{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ neofetch ];


  xdg.configFile.neofetch = {
    source = ./config;
    recursive = true;
  };

  # add to zshrc
  programs.zsh.initExtra = ''
    neofetch
  '';
}

