{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.system.openrazer;
in
with lib;
{
  options.${namespace}.system.openrazer = {
    enable = mkEnableOption "OpenRazer";
  };
  config = mkIf cfg.enable {
    hardware.openrazer.enable = true;

    environment.systemPackages = with pkgs; [
      openrazer-daemon
      polychromatic
    ];

    ${namespace} = {
      user.extraGroups = [ "openrazer" ];
    };
  };
}
