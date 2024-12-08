{
  lib,
  pkgs,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.cli-apps.btop;
in
  with lib;
  with lib.${namespace}; {
    options.${namespace}.cli-apps.btop = {enable = mkEnableOption "btop";};

    config = mkIf cfg.enable {
      programs.btop = {
        enable = true;
        settings = {
          color_theme = "nord";
          theme_background = false;
        };
      };
    };
  }
