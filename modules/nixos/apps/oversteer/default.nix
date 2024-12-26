{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.apps.oversteer;
in
with lib;
{
  options.${namespace}.apps.oversteer = {
    enable = mkEnableOption "Oversteer";
  };

  config = mkIf cfg.enable {
    boot = {
      blacklistedKernelModules = [
        "hid-thrustmaster" # T300rs drivers
      ];
      extraModulePackages = with config.boot.kernelPackages; [
        # T300rs drivers
        (hid-tmff2.overrideAttrs (oldAttrs: {
          version = "0.82";
          src = pkgs.fetchFromGitHub {
            owner = "Kimplul";
            repo = "hid-tmff2";
            rev = "11cca6d4e9b49ec3779573f68917e362e4d65d36";
            hash = "sha256-n20AwUzusY7ZjANrkPxvkD+qSqvu/YAUQJERAc3upto=";
            # For hid-tminit. Source: https://github.com/scarburato/hid-tminit
            fetchSubmodules = true;
          };
        }))
      ];
    };

    environment.systemPackages = with pkgs; [ oversteer ];
    services.udev.packages = with pkgs; [ oversteer ];
  };
}
