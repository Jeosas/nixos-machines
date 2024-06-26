{
  config,
  pkgs,
  inputs,
  ...
}: let
  username = "jeosas";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";
in {
  imports = [
    inputs.nurpkgs.hmModules.nur

    ../../home/common/theme.nix
    ../../home/desktop/i3
    ../../home/applications/neovim
    ../../home/applications/firefox.nix
    ../../home/tools/zsh.nix
    ../../home/tools/git.nix
    ../../home/tools/direnv.nix
    ../../home/tools/neofetch.nix
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

  home = {
    inherit username homeDirectory;

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.11";

    packages = with pkgs; [
      just
      edgedb
      nixgl.auto.nixGLDefault
    ];
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Setup home manager to run over arch
  targets.genericLinux.enable = true;
}
