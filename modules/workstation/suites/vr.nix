{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.${namespace}.workstation.suites.vr;
in
{
  options.${namespace}.workstation.suites.vr = {
    enable = mkEnableOption "Enable VR suite";
  };

  config = mkIf cfg.enable {
    ${namespace} = {
      apps = {
        steam.enable = true;
        wivrn.enable = true;
        envision.enable = true;
      };
    };
  };
}
