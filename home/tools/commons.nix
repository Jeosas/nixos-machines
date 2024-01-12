{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    just
    bat
    ranger
    ripgrep
    btop
    ncpamixer
  ];
}
