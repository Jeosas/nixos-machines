{
  pkgs,
  lib,
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

  cfg = config.jeomod.applications.alvr;
in
  with lib; {
    options.jeomod.applications.alvr = {
      enable = mkEnableOption "alvr";
    };

    config = mkIf cfg.enable {
      programs.steam.enable = true;
      home-manager.users.${config.jeomod.user}.home.packages = with pkgs; [alvr alvr_usb_forward];
      jeomod.system.impermanence.user.directories = [
        ".config/alvr"
        ".config/openvr"
        ".config/openxr"
      ];
      programs.adb.enable = true;
      jeomod.groups = ["adbusers"];
    };
  }
