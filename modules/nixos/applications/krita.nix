{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.jeomod.applications.krita;
in
  with lib; {
    options.jeomod.applications.krita = {
      enable = mkEnableOption "Krita";
    };

    config = mkIf cfg.enable {
      home-manager.users.${config.jeomod.user}.home.packages = with pkgs; [krita];
    };
  }
