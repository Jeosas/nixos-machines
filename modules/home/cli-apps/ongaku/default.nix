{
  lib,
  pkgs,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.cli-apps.ongaku;
in
  with lib; {
    options.${namespace}.cli-apps.ongaku = {enable = mkEnableOption "Ongaku";};

    config = mkIf cfg.enable {
      home.packages = with pkgs; [ongaku];
    };
  }
