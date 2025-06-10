{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.zsh;
in
{
  options.${namespace}.apps.zsh = {
    enable = mkEnableOption "zsh";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.${namespace}.user.enableHomeManager;
        message = "Home-manager is not enabled.";
      }
    ];

    home-manager.users.${config.${namespace}.user.name} = {
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
            jqfind () {
                ${pkgs.jq}/bin/jq '{"path": ([path(.. | select('$1'))|map(if type=="number" then "[\(.)]" else tostring end)|join(".")|split(".[]")|join("[]")]|unique|map("."+.)|.[]), "value": (.. | select('$1'))}'
            }

            bindkey -v
            export PATH=$HOME/.local/bin:$PATH
          '';
          shellAliases = { };
        };
      };
    };
  };
}
