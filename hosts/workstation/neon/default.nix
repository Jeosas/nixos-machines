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
        };
      };

      suites = {
        games.enable = true;
        streaming.enable = true;
        simracing.enable = true;
      };

      sshConfig = with hosts; {
        "github.com" = {
          Hostname = "github.com";
          User = "git";
          IdentityFile = "~/.ssh/id_github";
          IdentitiesOnly = true;
        };
        ${oxygen.network.hostName} = {
          Hostname = oxygen.network.ipv4;
          User = "jeosas";
          IdentityFile = "~/.ssh/id_homelab";
          IdentitiesOnly = true;
        };
        "${carbon.network.hostName}.unlock" = {
          Hostname = carbon.network.ipv4;
          User = "root";
          IdentityFile = "~/.ssh/id_homelab";
          IdentitiesOnly = true;
          HostKeyAlias = "initrd.carbon";
        };
        ${carbon.network.hostName} = {
          Hostname = carbon.network.ipv4;
          User = "jeosas";
          IdentityFile = "~/.ssh/id_homelab";
          IdentitiesOnly = true;
          HostKeyAlias = "carbon";
        };
        http001 = {
          Hostname = "195.15.193.41";
          Port = 22216;
          User = "maintainer";
          IdentityFile = "~/.ssh/id_innovlens";
          IdentitiesOnly = true;
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

  environment.persistence.main = {
    users.${config.${namespace}.user.name}.directories = [
      ".config/Melvor Idle"
    ];
  };

  system.stateVersion = "24.05";
}
