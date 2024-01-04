{ config, pkgs, inputs, ... }:

let
  username = "jb";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";
in
{
  imports = [
    inputs.nurpkgs.hmModules.nur

    ./monitors.nix

    ../../home/desktop/hyprland
    ../../home/applications/neovim
    ../../home/applications/firefox.nix
    ../../home/applications/alacritty.nix
    ../../home/tools/zsh.nix
    ../../home/tools/git.nix
    ../../home/tools/direnv.nix
    ../../home/tools/macchina.nix
    ../../home/tools/starship.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      inputs.nurpkgs.overlay
      inputs.nixgl.overlay
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
      xdg.configHome = configHome;
    };
  };

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  home = {
    inherit username homeDirectory;

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.05";

    packages = with pkgs; [
      just
      ranger
      nixgl.auto.nixGLDefault
    ];
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "Jean-Baptiste WINTERGERST";
    userEmail = "jbaptiste.wintergerst@preligens.com";
  };

  # Setup home manager to run over other distros
  targets.genericLinux.enable = true;
}

