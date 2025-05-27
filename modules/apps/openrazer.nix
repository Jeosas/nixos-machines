{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.${namespace}.apps.openrazer;
in
{
  options.${namespace}.apps.openrazer = {
    enable = mkEnableOption "OpenRazer";
  };
  config = mkIf cfg.enable {
    hardware.openrazer.enable = true;

    environment.systemPackages = with pkgs; [
      openrazer-daemon
      polychromatic
    ];

    ${namespace}.user.extraGroups = [ "openrazer" ];
  };
}
