{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.jeomod.system.bluetooth;
in
  with lib; {
    options.jeomod.system.bluetooth = {
      enable = mkEnableOption "Bluetooth";
    };

    config = mkIf cfg.enable {
      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = false;

      environment.systemPackages = with pkgs; [bluetuith];
    };
  }
