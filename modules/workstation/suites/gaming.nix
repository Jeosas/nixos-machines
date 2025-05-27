{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.workstation.suites.games;
in
{
  options.${namespace}.workstation.suites.games = {
    enable = mkEnableOption "Enable gaming suite.";
  };

  config = mkIf cfg.enable {
    ${namespace} = {
      apps = {
        steam.enable = true;
        heroic.enable = true;
        ankama-launcher.enable = true;
      };
    };
  };
}
