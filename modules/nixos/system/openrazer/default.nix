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

    environment.systemPackages = with pkgs; [ openrazer-daemon ];

    ${namespace} = {
      user.extraGroups = [ "openrazer" ];
    };

    home-manager.users.${config.${namespace}.user.name} = {
      home.packages = with pkgs; [ polychromatic ];
    };
  };
}
