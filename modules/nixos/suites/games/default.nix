{
  lib,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.suites.games;
in
with lib;
with lib.${namespace};
{
  options.${namespace}.suites.games = {
    enable = mkEnableOption "games suite";
  };

  config = mkIf cfg.enable {
    ${namespace} = {
      apps.steam = enabled;
    };

    home-manager.users.${config.${namespace}.user.name} = {
      ${namespace}.apps = {
        heroic = enabled;
        lutris = enabled;
        ankama-launcher = enabled;
      };
    };
  };
}
