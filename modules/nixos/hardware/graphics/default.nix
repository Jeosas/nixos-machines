{
  lib,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.hardware.graphics;
in
  with lib; {
    options.${namespace}.hardware.graphics = {
      enable = mkEnableOption "graphics";
    };

    config = mkIf cfg.enable {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
  }
