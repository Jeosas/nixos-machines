{
  lib,
  namespace,
  ...
}:
let
  host = lib.${namespace}.vars.hosts.carbon;

  rootSshKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGKX9dd66pamxqesJXHVGB7wDsiW7YgQcSFZ6lOKl/KC jeosas@neon"
  ];

  allSshKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGKX9dd66pamxqesJXHVGB7wDsiW7YgQcSFZ6lOKl/KC jeosas@neon"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILVVjp5r8ljglEvaHPlwMcVi859A+fVOO1rZe3MGbj0I jeosas@helium"
  ];
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
          authorizedKeys = rootSshKeys;
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
    useDHCP = true;
    nameservers = [ "9.9.9.9" ];
    firewall.enable = true;
  };

  time.timeZone = "Europe/Paris";
  services.ntp.enable = true;

  nix = {
    optimise = {
      automatic = true;
      dates = [ "03:45" ];
    };
    gc = {
      automatic = true;
      dates = "04:00";
      options = "-d --delete-older-than 7d";
    };
    settings = {
      experimental-features = "nix-command flakes";

      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  users.users.jeosas = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys = {
      keys = allSshKeys;
    };
  };
  users.users.root.openssh.authorizedKeys = {
    keys = rootSshKeys;
  };

  systemd.services.sshd.wantedBy = lib.mkOverride 40 [ "multi-user.target" ];
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    allowSFTP = false;
    extraConfig = ''
      AllowTcpForwarding yes
      X11Forwarding no
      AllowAgentForwarding no
      AllowStreamLocalForwarding no
      AuthenticationMethods publickey
    '';
    settings = {
      X11Forwarding = false;
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
      KbdInteractiveAuthentication = false;
    };
  };
  networking.firewall.allowedTCPPorts = [ 22 ];

  system.stateVersion = "25.11";
}
