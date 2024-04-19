{ config, pkgs, ... }:

{
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
  home-manager.users.jeosas.home.packages = with pkgs; [
    oversteer
    protonup-ng
  ];

  programs.steam = {
    enable = true;
    gamescopeSession = {
      enable = true;
    };
  };
}
