{
  hosts = {
    oxygen = {
      network = {
        hostName = "oxygen";
        ipv4 = "192.168.1.8";
      };
    };
    carbon = {
      network = {
        hostName = "carbon";
        ipv4 = "192.168.1.6";
      };
    };
  };

  keys = rec {
    helium = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILVVjp5r8ljglEvaHPlwMcVi859A+fVOO1rZe3MGbj0I jeosas@helium";
    neon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGKX9dd66pamxqesJXHVGB7wDsiW7YgQcSFZ6lOKl/KC jeosas@neon";

    adminKeys = [ neon ];
    userKeys = [
      neon
      helium
    ];
  };
}
