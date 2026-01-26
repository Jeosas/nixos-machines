{
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.vars) hosts;
in
{
  imports = [ ./hardware.nix ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  ${namespace} = {
    workstation = {
      hostName = "neon";

      hardware = {
        enableSSD = true;
        gpuVendor = "nvidia";
        enableBluetooth = true;
      };

      desktop = {
        hyprland = {
          monitors = [
            "DP-3,3440x1440@144,0x0,1"
            "HDMI-A-1,1920x1080@60,-1920x400,1"
          ];
          keyboard_device = "/dev/input/event5";
        };
        waybar.cpu-temp-zone = 2;
      };

      suites = {
        games.enable = true;
        streaming.enable = true;
        simracing.enable = true;
      };

      sshConfig = with hosts; {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "~/.ssh/id_github";
          identitiesOnly = true;
        };
        ${oxygen.network.hostName} = {
          hostname = oxygen.network.ipv4;
          user = "jeosas";
          identityFile = "~/.ssh/id_homelab";
          identitiesOnly = true;
        };
        "${carbon.network.hostName}.unlock" = {
          hostname = carbon.network.ipv4;
          user = "root";
          identityFile = "~/.ssh/id_homelab";
          identitiesOnly = true;
          extraOptions = {
            HostKeyAlias = "initrd.carbon";
          };
        };
        ${carbon.network.hostName} = {
          hostname = carbon.network.ipv4;
          user = "jeosas";
          identityFile = "~/.ssh/id_homelab";
          identitiesOnly = true;
          extraOptions = {
            HostKeyAlias = "carbon";
          };
        };
      };
    };

    apps = {
      docker.enableNvidia = true;
      libvirtd.enable = true;
      ollama = {
        enable = true;
        acceleration = "cuda";
      };
      openrazer.enable = true;
      wootility.enable = true;
    };
  };

  system.stateVersion = "24.05";
}
