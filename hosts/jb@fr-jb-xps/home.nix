{ config, pkgs, inputs, ... }:
let
  username = "jb";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";
in
{
  imports = [
    inputs.nurpkgs.hmModules.nur

    ./dev.nix
    ./regolith.nix
    ./keymap.nix

    ../../home/common/theme.nix
    ../../home/desktop/hyprland/dunst

    ../../home/applications/neovim
    ../../home/applications/alacritty.nix
    ../../home/tools/commons.nix
    ../../home/tools/zsh.nix
    ../../home/tools/git.nix
    ../../home/tools/direnv.nix
    ../../home/tools/fastfetch.nix
    ../../home/tools/starship.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
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
      (import ./houseKeeping.nix { inherit pkgs; })
      bluetuith
      autorandr
      logseq
    ];
  };

  # leave ubuntu manage
  xdg.mime.enable = false;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "Jean-Baptiste WINTERGERST";
    userEmail = "jbaptiste.wintergerst@preligens.com";
  };

  programs.zsh.shellAliases = {
    ssh = "TERM=xterm-256color ssh";
  };

  # Setup home manager to run over other distros
  targets.genericLinux.enable = true;
}

