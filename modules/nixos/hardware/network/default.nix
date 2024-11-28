{
  lib,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.hardware.network;
in
  with lib; {
    options.${namespace}.hardware.network = {
      enable = mkEnableOption "network";
      hostName = mkOption {
        type = types.str;
        description = "system hostname";
      };
    };

    config = mkIf cfg.enable {
      networking = {
        inherit (cfg) hostName;
        networkmanager.enable = true;
        firewall.enable = true;
      };
      ${namespace}.user.extraGroups = ["networkmanager"];
    };
  }
