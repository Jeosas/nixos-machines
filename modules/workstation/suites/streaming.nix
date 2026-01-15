{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.workstation.suites.streaming;
in
{
  options.${namespace}.workstation.suites.streaming = {
    enable = mkEnableOption "Enable streaming suite";
  };

  config = mkIf cfg.enable {
    ${namespace} = {
      apps.obs.enable = true;
    };
  };
}
