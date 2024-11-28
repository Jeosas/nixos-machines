{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.system.boot;
in {
  options.${namespace}.system.boot = {
    enable = mkEnableOption "boot";
    kernelPackages = mkOption {
      type = types.raw;
      description = "kernel package";
      default = pkgs.linuxPackages_latest;
    };
  };
  config = mkIf cfg.enable {
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      inherit (cfg) kernelPackages;
    };
  };
}
