{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.jj;
in
with lib;
{
  options.${namespace}.apps.jj = {
    enable = mkEnableOption "jj";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.${namespace}.user.enableHomeManager;
        message = "Home-manager is not enabled.";
      }
    ];

    ${namespace}.apps.git.enable = true;

    home-manager.users.${config.${namespace}.user.name} = {
      home.packages = with pkgs; [
        lazyjj
      ];

      programs = {
        jujutsu = {
          enable = true;
          settings = {
            user = {
              email = config.${namespace}.apps.git.userEmail;
              name = config.${namespace}.apps.git.userName;
            };
          };
        };
        zsh.shellAliases = {
          lj = "lazyjj";
        };
      };
    };
  };
}
