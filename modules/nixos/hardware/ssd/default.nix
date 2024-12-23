{
  lib,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.hardware.ssd;
in
{
  options.${namespace}.hardware.ssd = {
    enable = mkEnableOption "ssd";
  };

  config = mkIf cfg.enable { services.fstrim = enabled; };
}
