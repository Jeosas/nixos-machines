{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.mullvad-vpn;
in
{
  options.${namespace}.apps.mullvad-vpn = {
    enable = mkEnableOption "mullvad-vpn";
  };

  config = mkIf cfg.enable {
    services.mullvad-vpn.enable = true;
    ${namespace}.impermanence.directories = [ "/etc/mullvad-vpn" ];
  };
}
