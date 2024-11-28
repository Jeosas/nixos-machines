{lib, ...}: let
  hostInfo = (import ../../../hosts.nix).oxygen;
  ports.ssh = 22;
in {
  imports = [
    ../../../services/websites/thewinterdev-fr.nix
  ];

  sdImage.compressImage = false;

  system.stateVersion = "24.05";

  # Locale
  time.timeZone = "Europe/Paris";
  services.ntp.enable = true;

  # Users
  users.mutableUsers = false;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILVVjp5r8ljglEvaHPlwMcVi859A+fVOO1rZe3MGbj0I jeosas@helium"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGKX9dd66pamxqesJXHVGB7wDsiW7YgQcSFZ6lOKl/KC jeosas@neon"
  ];

  # Enable ssh
  systemd.services.sshd.wantedBy = lib.mkOverride 40 ["multi-user.target"];
  services.openssh = {
    enable = true;
    ports = with ports; [ssh];
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  # Networking
  networking = {
    defaultGateway = "192.168.1.254";
    hostName = hostInfo.hostName;
    interfaces.eth0.ipv4.addresses = [
      {
        address = hostInfo.ipv4;
        prefixLength = 24;
      }
    ];
    nameservers = ["9.9.9.9"];

    firewall = {
      enable = true;
      allowedTCPPorts = with ports; [ssh];
    };
  };
}
