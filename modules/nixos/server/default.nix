{
  lib,
  pkgs,
  namespace,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.server;

  ports = {
    ssh = 22;
  };
in
{

  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options.${namespace}.server = with lib.types; {
    enable = mkEnableOption "Enable base system for servers";
    hostName = mkOpt str "" "System hostname";
    users = {
      extraGroups =
        mkOpt (listOf str) [ ]
          "The Unix groups that server staff users should be assigned to";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.hostName != "";
        message = "hostName must be provided";
      }
    ];

    boot = {
      # bootloader
      loader = {
        grub = {
          enable = true;
          efiSupport = true;
          devices = [ "nodev" ]; # not used in UEFI
        };
        efi.canTouchEfiVariables = true;
      };

      # ssh at boot time
      kernelParams = [ "ip=dhcp" ];
      initrd = {
        availableKernelModules = [ "r8169" ]; # find with `lspci -v | grep -iA8 'network\|ethernet'`
        network = {
          enable = true;
          ssh = {
            enable = true;
            port = ports.ssh;
            authorizedKeys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGKX9dd66pamxqesJXHVGB7wDsiW7YgQcSFZ6lOKl/KC"
            ];
            hostKeys = [ "/etc/secrets/initrd/ssh_host_rsa_key" ];
            shell = "/bin/cryptsetup-askpass";
          };
        };
      };
    };

    # nix
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
    };

    # doas
    security = {
      sudo.enable = false;
      doas = {
        enable = true;
        extraRules = [
          {
            groups = [ "wheel" ];
            persist = true;
          }
        ];
      };
    };

    # # auditd
    # security = {
    #   auditd.enable = true;
    #   audit = {
    #     enable = true;
    #     rules = [
    #       "-a exit,always -F arch=b64 -S execve"
    #     ];
    #   };
    # };

    # staff users
    users.users =
      let
        mkUser =
          {
            keys,
            extraGroups ? cfg.users.extraGroups,
            ...
          }:
          {
            mutableUsers = false;
            isNormalUser = true;
            extraGroups = extraGroups ++ [ "wheel" ];
            shell = pkgs.zsh;
            openssh.authorizedKeys = {
              inherit keys;
            };
          };
      in
      {
        jeosas = mkUser {
          keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGKX9dd66pamxqesJXHVGB7wDsiW7YgQcSFZ6lOKl/KC" ];
        };
      };
    programs.zsh.enable = true;

    # package reset
    environment.defaultPackages = lib.mkForce [ ];

    # openssh
    services.openssh = {
      ports = [ ports.ssh ];
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
        PermitRootLogin = "no";
        kbdInteractiveAuthentication = false;
      };
    };

    # netrwork
    networking = {
      inherit (cfg) hostName;
      firewall = {
        enable = true;
        allowedTCPPorts = builtins.attrValues ports;
      };
      nameservers = [ "9.9.9.9" ];
      hostId = "30e20076";
    };

    # impermanence
    boot = {
      tmp.cleanOnBoot = true;
      initrd.postDeviceCommands = lib.mkAfter ''
        zfs rollback -r zboot/local/root@blank
      '';
    };
    fileSystems = {
      "/etc/nixos".options = [ "noexec" ];
      "/srv".options = [ "noexec" ];
      "/var/lib".options = [ "noexec" ];
    };
    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/etc/nixos" # nixos system config files
        "/srv" # service data
        "/var/lib" # system service persistent data
      ];
      files = [
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/secrets/initrd/ssh_host_rsa_key"
        # "/etc/machine-id"
      ];
    };
  };
}
