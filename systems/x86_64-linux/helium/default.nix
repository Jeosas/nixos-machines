{
  lib,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace};
{
  imports = [
    ./battery.nix
    ./hardware.nix
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  ${namespace} = {
    suites = {
      art = enabled;
      base-workstation = enabled;
      laptop = enabled;
      development = enabled;
      music = {
        enable = true;
        dj = enabled;
      };
      social = enabled;
    };

    hardware.network.hostName = "helium";
    hardware.bluetooth = enabled;

    desktop = {
      hyprland.config = {
        monitors = [
          "eDP-1,1920x1080@60,auto,1"
          "HDMI-A-1,1920x1080@60,auto,1"
          ",preferred,auto,1"
        ];
      };
    };

    system.keyd = enabled;
  };

  home-manager.users.${config.${namespace}.user.name}.${namespace} = {
    desktop = {
      addons.waybar = {
        cpu-temp-zone = 6;
      };
    };
    tools.ssh.user.config = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_github";
        identitiesOnly = true;
      };
      "oxygen" = {
        hostname = "192.168.1.8";
        user = "root";
        identityFile = "~/.ssh/id_homelab";
        identitiesOnly = true;
      };
    };
  };

  # Firmeare update software
  services.fwupd.enable = true;

  # Trackpoint
  hardware = {
    trackpoint = {
      enable = true;
      emulateWheel = true;
    };
  };

  system.stateVersion = "24.05";
}
