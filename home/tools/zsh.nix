{...}: {
  # zsh
  programs = {
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
      '';
      shellAliases = {
        nn = "nvim --cmd 'cd ~/notes' ~/notes";
      };
    };

    # starship
    starship.enableZshIntegration = true;

    # direnv
    direnv.enableZshIntegration = true;
  };
}
