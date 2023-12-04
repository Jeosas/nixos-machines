{ config, pkgs, inputs, ... }:

let
  username = "jeosas";
  homeDirectory = "/home/${username}";
in
{
  imports = [
    inputs.nurpkgs.hmModules.nur

    ../../home/applications/neovim
    ../../home/tools/zsh.nix
    ../../home/tools/git.nix
    ../../home/tools/direnv.nix
    ../../home/tools/neofetch.nix
    ../../home/tools/starship.nix
  ];

  home = {
    inherit username homeDirectory;

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.05";

    packages = with pkgs; [
      just
    ];
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  programs.home-manager.enable = true;
  programs.git.enable = true;
}

