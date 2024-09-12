{
  pkgs,
  config,
  ...
}: {
  programs.zsh.enable = true;

  home-manager.users.${config.jeomod.user}.programs = {
    zsh = {
      enable = true;
      dotDir = ".config/zsh";
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autocd = true;
      history = {
        expireDuplicatesFirst = true;
      };
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
        ];
      };
      initExtra = ''
        export PATH=$HOME/.local/bin:$PATH

        ${pkgs.chafa}/bin/chafa --size=60x25 ${./shell-init-logo.png}
      '';
      shellAliases = {};
    };

    # starship
    starship.enableZshIntegration = true;

    # direnv
    direnv.enableZshIntegration = true;
  };
}
