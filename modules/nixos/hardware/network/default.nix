{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkOpt xor;

  cfg = config.${namespace}.hardware.network;
in
{
  options.${namespace}.hardware.network = with lib.types; {
    enable = mkEnableOption "network";
    hostName = mkOpt str "" "system hostname";
    enableNetworkManager = mkOpt bool false "enable NetworkManager";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.hostName != "";
        message = "hostName must be provided";
      }
    ];

    networking = {
      inherit (cfg) hostName;
      firewall.enable = true;

      networkmanager.enable = cfg.enableNetworkManager;

      nameservers = [ "9.9.9.9" ];
    };
    ${namespace}.user.extraGroups = [ "networkmanager" ];
  };
}
