{
  lib,
  pkgs,
  namespace,
  config,
  ...

}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.libvirtd;
in
{
  options.${namespace}.apps.libvirtd = {
    enable = mkEnableOption "libvirtd";
  };

  config = mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
        vhostUserPackages = [ pkgs.virtiofsd ];
      };
      nss = {
        enable = true;
        enableGuest = true;
      };
      allowedBridges = [
        "virbr0"
      ];
    };

    networking.firewall.trustedInterfaces = [
      "virbr0"
    ];

    programs.virt-manager.enable = true;

    ${namespace} = {
      user.extraGroups = [ "libvirtd" ];
    };
  };
}
