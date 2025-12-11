{
  lib,
  namespace,
  config,
  modulesPath,
  ...
}:
let
  inherit (lib) mkForce;
  inherit (lib.${namespace}) mkOpt mkOptRequired;

  cfg = config.${namespace}.server-legacy;

  ports = {
    ssh = 22;
  };

  sshKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGKX9dd66pamxqesJXHVGB7wDsiW7YgQcSFZ6lOKl/KC jeosas@neon"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILVVjp5r8ljglEvaHPlwMcVi859A+fVOO1rZe3MGbj0I jeosas@helium"
  ];
in
{
  imports = [
    "${modulesPath}/profiles/headless.nix"
    "${modulesPath}/profiles/minimal.nix"

    ../sops.nix
    ../user.nix
    ../impermanence.nix
    ./mixins/rpi3.nix
  ]
  ++ import ../module-list.nix;

  options.${namespace}.server-legacy = with lib.types; {
    hostName = mkOptRequired str "System hostname";
    impermanenceEnabled = mkOpt bool true "Enable impermanence";
  };

  config = {
    documentation = {
      nixos.enable = false;
      man.enable = false;
    };
    boot = {
      tmp.cleanOnBoot = true;
    };
    environment.defaultPackages = [ ];
    xdg = {
      icons.enable = false;
      mime.enable = false;
      sounds.enable = false;
    };

    networking = {
      inherit (cfg) hostName;
      useDHCP = true;
      firewall = {
        enable = true;
        allowedTCPPorts = builtins.attrValues ports;
      };
      nameservers = [ "9.9.9.9" ];
    };

    # doas
    security = {
      sudo.enable = false;
      doas = {
        enable = true;
        extraRules = [ { groups = [ "wheel" ]; } ];
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

    # openssh
    systemd.services.sshd.wantedBy = lib.mkOverride 40 [ "multi-user.target" ];
    services.openssh = {
      enable = true;
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
        PermitRootLogin = "prohibit-password";
        KbdInteractiveAuthentication = false;
      };
    };

    # Impermanence
    environment.persistence.main = {
      directories = [
        "/etc/nixos" # nixos system config files
        "/var/lib/nixos" # nixos stuff
      ];
      files = [
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/machine-id"
      ];
    };

    users.users.root.openssh.authorizedKeys = {
      keys = sshKeys;
    };

    ${namespace} = {
      user = {
        inherit sshKeys;
        enableHomeManager = mkForce false;
      };
      sops.secretFile = ../../secrets/oxygen.yaml;
    };
  };
}
