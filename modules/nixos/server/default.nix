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
      listenAddresses = [
        {
          addr = "192.168.1.0";
          port = ports.ssh;
        }
      ];
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
    };

    # impermanence
    boot.tmp.cleanOnBoot = true;
    fileSystems = {
      "/etc/nixos".options = "noexec";
      "/srv".options = "noexec";
      "/var/lib".options = "noexec";
      "/var/log".options = "noexec";
    };
    environment = {
      persistence."/nix/persist" = {
        directories = [
          "/etc/nixos" # nixos system config files
          "/srv" # service data
          "/var/lib" # system service persistent data
          "/var/log" # the place that journald dumps it logs to
        ];
      };

      etc = {
        "ssh/ssh_host_rsa_key".source = "/nix/persist/etc/ssh/ssh_host_rsa_key";
        "ssh/ssh_host_rsa_key.pub".source = "/nix/persist/etc/ssh/ssh_host_rsa_key.pub";
        "ssh/ssh_host_ed25519_key".source = "/nix/persist/etc/ssh/ssh_host_ed25519_key";
        "ssh/ssh_host_ed25519_key.pub".source = "/nix/persist/etc/ssh/ssh_host_ed25519_key.pub";
        "machine-id".source = "/nix/persist/etc/machine-id";
      };
    };

  };
}
