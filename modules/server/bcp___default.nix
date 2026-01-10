{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkForce;
  inherit (lib.${namespace}) mkOptRequired;

  cfg = config.${namespace}.server;

  ports = {
    ssh = 22;
  };
in
{
  imports = [
    ../user.nix
    ../impermanence.nix
    ./mixins/rpi3.nix
  ]
  ++ import ../module-list.nix;

  options.${namespace}.server = with lib.types; {
    hostName = mkOptRequired str "System hostname";
  };

  config = {
    boot = {
      # bootloader
      loader = {
        grub = {
          enable = true;
          efiSupport = true;
          devices = lib.mkForce [ ];
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
        efi.canTouchEfiVariables = false;
      };

      supportedFilesystems = [ "zfs" ];

      # ssh at boot time
      initrd = {
        network = {
          enable = true;
          ssh = {
            enable = true;
            port = ports.ssh;
            authorizedKeys = config.${namespace}.user.sshKeys;
            hostKeys = [
              "/etc/secrets/initrd/ssh_host_ed25519_key"
            ];
          };
          postCommands = ''
            cat <<EOF > /root/.profile
            zfs import -a
            zfs load-key -a
            EOF
          '';
        };
      };
    };

    # nix
    documentation.nixos.enable = false;
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

    # doas
    security = {
      sudo.enable = false;
      doas = {
        enable = true;
        extraRules = [ { groups = [ "wheel" ]; } ];
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

    # locale
    i18n =
      let
        locale = "en_US.UTF-8";
      in
      {
        defaultLocale = locale;
        supportedLocales = [ "${locale}/UTF-8" ];
      };

    # time (ntp)
    time.timeZone = "Europe/Paris";
    services.ntp.enable = true;

    # package reset
    environment.defaultPackages = lib.mkForce [ ];

    # openssh
    systemd.services.sshd.wantedBy = lib.mkOverride 40 [ "multi-user.target" ];
    services.openssh = {
      ports = [ ports.ssh ];
      allowSFTP = false;
      extraConfig = ''
        AllowTcpForwarding no
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

    # network
    networking = {
      inherit (cfg) hostName;
      useDHCP = true;
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
        zfs rollback -r zfaststorage/local/root@blank
      '';
    };

    environment.persistence.main = {
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
        "/etc/machine-id"
      ];
    };

    ${namespace} = {
      impermanence.enable = true;
      # staff users
      user = {
        sshKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGKX9dd66pamxqesJXHVGB7wDsiW7YgQcSFZ6lOKl/KC jeosas@neon"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILVVjp5r8ljglEvaHPlwMcVi859A+fVOO1rZe3MGbj0I jeosas@helium"
        ];
        enableHomeManager = mkForce false;
      };
    };

    programs.vim.enable = true;
  };
}
