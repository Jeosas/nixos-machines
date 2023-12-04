{ config, pkgs, inputs, ... }:

let
  username = "jeosas";
  homeDirectory = "/home/${username}";
in
{
  imports = [
    inputs.nurpkgs.hmModules.nur

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

  home = {
    inherit username homeDirectory;
    stateVersion = "24.05"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    language.base = "en_US.UTF-8";
    packages = with pkgs; [
      just
      (import ./houseKeeping.nix { inherit pkgs; })
      ncpamixer
    ];
    sessionVariables = {
      # hyprland nvidia fix
      LIBVA_DRIVER_NAME = "nvidia";
      XDG_SESSION_TYPE = "wayland";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = "1";
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  programs.home-manager.enable = true;
  programs.git.enable = true;
}

