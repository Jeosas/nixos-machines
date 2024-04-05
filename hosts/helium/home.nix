{ config, pkgs, inputs, ... }:

let
  username = "jeosas";
  homeDirectory = "/home/${username}";
in
{
  imports = [
    inputs.nurpkgs.hmModules.nur

    ./monitors.nix
    ./keymap.nix

    ../../home/desktop/hyprland
    ../../home/applications/neovim
    ../../home/applications/firefox.nix
    ../../home/applications/alacritty.nix
    ../../home/tools/commons.nix
    ../../home/tools/zsh.nix
    ../../home/tools/git.nix
    ../../home/tools/direnv.nix
    ../../home/tools/fastfetch.nix
    ../../home/tools/starship.nix
  ];

  home = {
    inherit username homeDirectory;
    stateVersion = "24.05"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    language.base = "en_US.UTF-8";
    packages = with pkgs; [
      (import ./houseKeeping.nix { inherit pkgs; })
      signal-desktop
      logseq
    ];
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  programs.home-manager.enable = true;
  programs.git.enable = true;
}

