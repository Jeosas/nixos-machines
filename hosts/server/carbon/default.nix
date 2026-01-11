{
  lib,
  namespace,
  ...
}:
let
  host = lib.${namespace}.vars.hosts.carbon;
  inherit (lib.${namespace}.vars) keys;
in
{
  imports = [
    ./hardware.nix
  ];

  boot = {
    supportedFilesystems = [ "zfs" ];
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev"; # or "nodev" for efi only
        copyKernels = true;
        mirroredBoots = [
          {
            path = "/boot";
            devices = [ "/dev/disk/by-uuid/083D-FC66" ];
          }
          {
            path = "/boot-fallback";
            devices = [ "/dev/disk/by-uuid/0D5A-3239" ];
          }
        ];
      };
    };

    kernelModules = [ "r8169" ];
    initrd = {
      kernelModules = [ "r8169" ];
      network = {
        enable = true;
        udhcpc.extraArgs = [
          "-t"
          "20"
        ];
        ssh = {
          enable = true;
          port = 22;
          hostKeys = [
            "/nix/secret/initrd/ssh_host_ed25519_key"
          ];
          authorizedKeys = keys.userKeys;
        };
        postCommands = ''
          zpool import -a
          echo "zfs load-key -a && killall zfs" >> /root/.profile
        '';
      };
    };
  };

  networking = {
    inherit (host.network) hostName;
    hostId = "30e20076";
  };

  system.stateVersion = "25.11";
}
