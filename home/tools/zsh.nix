{ config, pkgs, ... }:

{
  # zsh
  programs.zsh = {
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
  };


  # starship
  programs.starship.enableZshIntegration = true;

  # direnv
  programs.direnv.enableZshIntegration = true;
}
