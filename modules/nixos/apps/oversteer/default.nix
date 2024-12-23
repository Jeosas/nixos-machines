{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.apps.oversteer;
in
with lib;
{
  options.${namespace}.apps.oversteer = {
    enable = mkEnableOption "Oversteer";
  };

  config = mkIf cfg.enable {
    boot.blacklistedKernelModules = [
      "hid-thrustmaster" # T300rs drivers
    ];
    boot.extraModulePackages = with config.boot.kernelPackages; [
      hid-tmff2 # T300rs drivers
    ];

    services.udev.packages = with pkgs; [ oversteer ];

    home-manager.users.${config.${namespace}.user.name} = {
      home.packages = with pkgs; [ oversteer ];
    };
  };
}
