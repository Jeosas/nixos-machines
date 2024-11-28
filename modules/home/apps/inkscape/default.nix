{
  lib,
  pkgs,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.apps.inkscape;
in
  with lib; {
    options.${namespace}.apps.inkscape = {enable = mkEnableOption "inkscape";};

    config = mkIf cfg.enable {
      home.packages = with pkgs; [inkscape];
    };
  }
