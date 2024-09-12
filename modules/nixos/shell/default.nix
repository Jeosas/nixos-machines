{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./onegaishimasu.nix
    ./zsh.nix
    ./starship.nix
    ./git.nix
    ./direnv.nix
    ./yazi.nix
  ];

  home-manager.users.${config.jeomod.user} = {
    home.packages = with pkgs; [
      btop
      bat
      ripgrep
      just
    ];

    programs.home-manager.enable = true;

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";
  };
}
