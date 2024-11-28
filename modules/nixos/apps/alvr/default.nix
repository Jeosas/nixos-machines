{
  lib,
  pkgs,
  namespace,
  config,
  ...
}: let
  alvr_usb_forward = pkgs.writeShellApplication {
    name = "alvr_usb_forward";
    runtimeInputs = with pkgs; [android-tools coreutils];
    text = ''
      @echo off
      adb start-server
      adb forward tcp:9943 tcp:9943
      adb forward tcp:9944 tcp:9944
      ECHO "To stop the server, hit any key"
      PAUSE
      adb kill-server
    '';
  };

  cfg = config.${namespace}.apps.alvr;
in
  with lib; {
    options.${namespace}.apps.alvr = {enable = mkEnableOption "alvr";};

    config = mkIf cfg.enable {
      programs.adb.enable = true;

      home-manager.users.${config.${namespace}.user.name} = {
        home.packages = with pkgs; [alvr alvr_usb_forward];

        ${namespace}.impermanence.directories = [
          ".config/alvr"
          ".config/openvr"
          ".config/openxr"
        ];
      };

      ${namespace} = {
        user.extraGroups = ["adbusers"];
      };
    };
  }
