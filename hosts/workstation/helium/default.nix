{
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.vars) hosts;
in
{
  imports = [
    ./hardware.nix
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  ${namespace} = {
    workstation = {
      hostName = "helium";

      hardware = {
        enableSSD = true;
        enableLaptopUtils = true;
        enableBluetooth = true;
      };

      desktop = {
        hyprland.monitors = [
          "eDP-1,1920x1080@60,auto,1"
          "HDMI-A-1,1920x1080@60,auto,1"
          ",preferred,auto,1"
        ];
        waybar.cpu-temp-zone = 6;
      };

      # suite = { };

      sshConfig = with hosts; {
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

    apps = {
      keyd.enable = true;
      mixxx.enable = true;
      ongaku.enable = true;
    };
  };

  system.stateVersion = "24.05";
}
