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
      home.packages = with pkgs; [btop];
    };
  }
