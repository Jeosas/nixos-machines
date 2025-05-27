{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.wireguard;
in
{
  options.${namespace}.apps.wireguard = {
    enable = mkEnableOption "wireguard";
  };

  config = mkIf cfg.enable {
    networking.wg-quick.interfaces.wg0.configFile = "/persist/wg0.conf";
  };
}
