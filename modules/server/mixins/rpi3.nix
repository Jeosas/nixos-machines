{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkForce;

  cfg = config.${namespace}.server.mixins.rpi3;
in
{
  options.${namespace}.server.mixins.rpi3 = {
    enable = mkEnableOption "Enable rpi3 specific config.";
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
        grub.enable = mkForce false;
        generic-extlinux-compatible.enable = mkForce true;
      };
    };
  };
}
