{ config, pkgs, ... }:

let
  alvr_usb_forward = pkgs.writeShellApplication {
    name = "alvr_usb_forward";
    runtimeInputs = with pkgs; [ android-tools coreutils  ];
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
in {
  boot.blacklistedKernelModules = [
    "hid-thrustmaster" # T300rs drivers
  ];
  # boot.kernelModules = [
  #   "hid-tmff2" # T300rs drivers
  # ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    hid-tmff2 # T300rs drivers
  ];

  services.udev.packages = with pkgs; [ oversteer ];
  home-manager.users.jeosas = {
    home.packages = with pkgs; [
      oversteer
      protonup-ng
      heroic

      mangohud

      # VR
      alvr
      alvr_usb_forward
    ];

    programs.mangohud = {
      enable = true;
      settings = {
        fps_only = 1;
        fps_limit=120; # for fallout 3
      };
    };
  };

  programs.adb.enable = true;
  users.users.jeosas.extraGroups = ["adbusers"];

  programs.steam = {
    enable = true;
  };
}

