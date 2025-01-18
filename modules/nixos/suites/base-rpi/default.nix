{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.suites.base-rpi;
in
{
  options.${namespace}.suites.base-rpi = {
    enable = mkEnableOption "base workstation suite";
  };

  config = mkIf cfg.enable {
    # Fix `Module ahci not found` issue
    # https://github.com/NixOS/nixpkgs/issues/154163
    nixpkgs.overlays = [
      (final: super: {
        makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
      })
    ];

    hardware.enableRedistributableFirmware = true;

    boot = {
      loader = {
        grub.enable = false;
        generic-extlinux-compatible.enable = true;
      };
      tmp.cleanOnBoot = true;
    };

    documentation.nixos.enable = false;

    ${namespace} = {
      hardware.network = enabled;
      system.time = enabled;
      services.openssh = enabled;
    };
  };
}
