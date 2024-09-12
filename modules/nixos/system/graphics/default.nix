{
  config,
  lib,
  ...
}: let
  cfg = config.jeomod.system.graphics;
in
  with lib; {
    imports = [./nvidia.nix];

    options.jeomod.system.graphics = {
      enable = mkEnableOption "Graphics";
    };

    config = mkIf cfg.enable {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
  }
