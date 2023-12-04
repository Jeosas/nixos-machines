{ config, pkgs, ... }:

{
  programs.direnv = {
    enable = true;
  };

  xdg.configFile.direnvrc = {
    source = ./direnrc;
    target = "direnv/direnvrc";
  };
}
