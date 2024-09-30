{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.jeomod.applications.ankama-launcher;
in
  with lib; {
    options.jeomod.applications.ankama-launcher = {
      enable = mkEnableOption "Ankama Launcher";
    };

    config = mkIf cfg.enable {
      home-manager.users.${config.jeomod.user}.home.packages = with pkgs; [ankama-launcher];
      jeomod.system.impermanence.user.directories = [
        ".config/zaap"
        ".config/Ankama"
        ".config/Ankama Launcher"
      ];
    };
  }
