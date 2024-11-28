{
  lib,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.suites.games.simracing;
in
  with lib;
  with lib.${namespace}; {
    options.${namespace}.suites.games.simracing = {enable = mkEnableOption "simracing suite";};

    config = mkIf cfg.enable {
      ${namespace} = {
        apps.oversteer = enabled;
      };
    };
  }
