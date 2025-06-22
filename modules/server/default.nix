{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkForce;
  inherit (lib.${namespace}) mkOpt;

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
  ] ++ import ../module-list.nix;

  options.${namespace}.server = with lib.types; {
    hostName = mkOpt str "" "System hostname";
  };

  config = {
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
      initrd = {
        network = {
          enable = true;
          ssh = {
            enable = true;
            port = ports.ssh;
            authorizedKeys = config.${namespace}.user.sshKeys;
            hostKeys = [ ./secret-key ];
          };
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
        zfs rollback -r zboot/local/root@blank
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
        # "/etc/secrets/initrd/ssh_host_rsa_key" # TODO replace me with sops secrets
        # "/etc/machine-id"
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
