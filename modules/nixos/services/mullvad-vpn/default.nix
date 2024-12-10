{
  lib,
  pkgs,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.services.mullvad-vpn;
in
  with lib; {
    options.${namespace}.services.mullvad-vpn = {enable = mkEnableOption "mullvad-vpn";};

    config = mkIf cfg.enable {
      services.mullvad-vpn.enable = true;
      ${namespace}.impermanence.directories = ["/etc/mullvad-vpn"];
    };
  }
