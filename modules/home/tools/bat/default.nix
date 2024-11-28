{
  lib,
  pkgs,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.tools.bat;
in
  with lib;
  with lib.${namespace}; {
    options.${namespace}.tools.bat = {enable = mkEnableOption "bat";};

    config = mkIf cfg.enable {
      home.packages = with pkgs; [bat];
    };
  }
