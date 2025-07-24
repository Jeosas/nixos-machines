{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.bash;
in
{
  options.${namespace}.apps.bash = {
    enable = mkEnableOption "bash";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.${namespace}.user.enableHomeManager;
        message = "Home-manager is not enabled.";
      }
    ];

    environment.pathsToLink = [ "/share/bash-completion" ];

    home-manager.users.${config.${namespace}.user.name} = {
      programs = {
        bash = {
          enable = true;
          enableCompletion = true;
          enableVteIntegration = true;
          historyControl = [
            "erasedups"
            "ignorespace"
          ];
          sessionVariables = {
            PATH = "$HOME/.local/bin:$PATH";
          };
          shellAliases = {
            "..." = "../..";
            "...." = "../../..";
            "....." = "../../../..";
            "......" = "../../../../..";
          };
          bashrcExtra = ''
            # notify end of long running tasks (more than 10s)
            . ${pkgs.undistract-me}/etc/profile.d/undistract-me.sh

            jqfind () {
                ${pkgs.jq}/bin/jq '{"path": ([path(.. | select('$1'))|map(if type=="number" then "[\(.)]" else tostring end)|join(".")|split(".[]")|join("[]")]|unique|map("."+.)|.[]), "value": (.. | select('$1'))}'
            }
          '';
        };
      };
    };
  };
}
