{
  pkgs,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    "${modulesPath}/profiles/base.nix"
    "${modulesPath}/profiles/all-hardware.nix"

    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    "${modulesPath}/installer/cd-dvd/channel.nix"
  ];

  config = {
    # EFI + USB bootable
    isoImage.makeEfiBootable = true;
    isoImage.makeUsbBootable = true;

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

    users.users.root.initialPassword = "root";
    services.openssh.settings.PermitRootLogin = lib.mkForce "yes";
    systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];

    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.hostName = "iso";
  };
}
