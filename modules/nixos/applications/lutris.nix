{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.jeomod.applications.lutris;
in
  with lib; {
    options.jeomod.applications.lutris = {
      enable = mkEnableOption "Luris";
    };

    config = mkIf cfg.enable {
      home-manager.users.${config.jeomod.user}.home.packages = with pkgs; [lutris];
      jeomod.system.impermanence.user.directories = ["local/share/lutris"];
    };
  }
