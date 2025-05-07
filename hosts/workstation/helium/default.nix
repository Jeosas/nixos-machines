{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib.${namespace}.vars) hosts;
in
{
  imports = [
    ./battery.nix
    ./hardware.nix
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  ${namespace} = {
    suites = {
      art.enable = true;
      base-workstation.enable = true;
      laptop.enable = true;
      development.enable = true;
      music = {
        enable = true;
        dj.enable = true;
      };
      social.enable = true;
    };

    hardware.network.hostName = "helium";
    hardware.bluetooth.enable = true;

    desktop = {
      hyprland.config = {
        monitors = [
          "eDP-1,1920x1080@60,auto,1"
          "HDMI-A-1,1920x1080@60,auto,1"
          ",preferred,auto,1"
        ];
      };
    };

    system.keyd.enable = true;
  };

  home-manager.users.${config.${namespace}.user.name}.${namespace} = {
    desktop = {
      addons.waybar = {
        cpu-temp-zone = 6;
      };
    };
    tools.ssh.user.config = with hosts; {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_github";
        identitiesOnly = true;
      };
      ${oxygen.network.hostName} = {
        hostname = oxygen.network.ipv4;
        user = "root";
        identityFile = "~/.ssh/id_homelab";
        identitiesOnly = true;
      };
    };
  };

  # Firmware update software
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
