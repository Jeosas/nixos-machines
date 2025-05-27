{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.services.wireguard;
in
{
  options.${namespace}.services.wireguard = {
    enable = mkEnableOption "wireguard";
  };

  config = mkIf cfg.enable {
    networking.wg-quick.interfaces.wg0.configFile = "/persist/wg0.conf";
  };
}
