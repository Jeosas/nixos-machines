{
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.vars) keys;

  sshPort = 22;
in
{
  imports = [
    # ../sops.nix
    ../user.nix
    ../impermanence.nix
  ]
  ++ import ../module-list.nix;

  config = {
    # networking
    networking = {
      useDHCP = true;
      nameservers = [ "9.9.9.9" ];
      firewall.enable = true;
    };

    # root user
    users.users.root.openssh.authorizedKeys = {
      keys = keys.userKeys;
    };

    # doas
    security = {
      sudo.enable = false;
      doas = {
        enable = true;
        extraRules = [ { groups = [ "wheel" ]; } ];
      };
    };

    # ssh
    systemd.services.sshd.wantedBy = lib.mkOverride 40 [ "multi-user.target" ];
    services.openssh = {
      enable = true;
      ports = [ sshPort ];
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
    networking.firewall.allowedTCPPorts = [ sshPort ];

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

    # impermanence
    boot = {
      tmp.cleanOnBoot = true;
      initrd.postDeviceCommands = lib.mkAfter ''
        zfs rollback -r rfastpool/local/root@blank
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
      # impermanence
      impermanence.enable = true;

      # user
      user = {
        enableHomeManager = false;
        sshKeys = keys.userKeys;
      };
    };
  };
}
