{
  lib,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.suites.games.vr;
in
  with lib;
  with lib.${namespace}; {
    options.${namespace}.suites.games.vr = {enable = mkEnableOption "VR suite";};

    config = mkIf cfg.enable {
      ${namespace} = {
        apps = {
          steam = enabled;
          alvr = enabled;
        };
      };
    };
  }
