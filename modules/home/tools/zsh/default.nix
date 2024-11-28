{
  lib,
  pkgs,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.tools.zsh;
in
  with lib;
  with lib.${namespace}; {
    options.${namespace}.tools.zsh = {
      enable = mkEnableOption "zsh";
    };
    config = mkIf cfg.enable {
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

            ${pkgs.chafa}/bin/chafa --size=60x25 ${./shell-init-logo.png}
          '';
          shellAliases = {};
        };
      };
    };
  }
