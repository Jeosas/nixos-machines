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
        hyprland = {
          hostConfigGroup = "hyprland-helium";
        };
      };

      # suite = { };

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
