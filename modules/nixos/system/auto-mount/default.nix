{
  lib,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.system.auto-mount;
in
{
  options.${namespace}.system.auto-mount = {
    enable = mkEnableOption "auto mount";
  };
  config = mkIf cfg.enable {
    services = {
      devmon.enable = true;
      udisks2.enable = true;
    };
  };
}
