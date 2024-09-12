{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.jeomod.applications.oversteer;
in
  with lib; {
    options.jeomod.applications.oversteer = {
      enable = mkEnableOption "Oversteer";
    };

    config = mkIf cfg.enable {
      boot.blacklistedKernelModules = [
        "hid-thrustmaster" # T300rs drivers
      ];
      boot.extraModulePackages = with config.boot.kernelPackages; [
        hid-tmff2 # T300rs drivers
      ];
      services.udev.packages = with pkgs; [oversteer];
      home-manager.users.${config.jeomod.user}.home.packages = with pkgs; [oversteer];
    };
  }
