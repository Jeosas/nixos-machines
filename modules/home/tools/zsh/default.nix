{
  lib,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.tools.zsh;
in
with lib;
with lib.${namespace};
{
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
        autosuggestion.enable = true;
        autocd = true;
        history = {
          expireDuplicatesFirst = true;
        };
        oh-my-zsh = {
          enable = true;
          plugins = [ "git" ];
        };
        initContent = ''
          export PATH=$HOME/.local/bin:$PATH
        '';
        shellAliases = { };
      };
    };
  };
}
