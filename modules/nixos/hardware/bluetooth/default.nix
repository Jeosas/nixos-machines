{
  lib,
  pkgs,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.hardware.bluetooth;
in
  with lib; {
    options.${namespace}.hardware.bluetooth = {enable = mkEnableOption "Bluetooth";};

    config = mkIf cfg.enable {
      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = false;

      environment.systemPackages = with pkgs; [bluetuith];
    };
  }
