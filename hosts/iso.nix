{
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    "${modulesPath}/profiles/minimal.nix"
    "${modulesPath}/profiles/all-hardware.nix"
  ];

  config = {
    environment.systemPackages = with pkgs; [
      vim
      git
    ];

    nix = {
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      extraOptions = "experimental-features = nix-command flakes";
    };

    systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
    users.users.nixos.initialHashedPassword = lib.mkForce null;
    users.users.nixos.password = "nixos";

    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.hostName = "nixos-iso";
  };
}
