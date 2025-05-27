{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.workstation.suites.simracing;
in
{
  options.${namespace}.workstation.suites.simracing = {
    enable = mkEnableOption "Enable simracing suite";
  };

  config = mkIf cfg.enable {
    ${namespace} = {
      apps.oversteer.enable = true;
    };
  };
}
