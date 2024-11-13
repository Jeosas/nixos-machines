{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.jeomod.applications.ongaku;
in
  with lib; {
    options.jeomod.applications.ongaku = {
      enable = mkEnableOption "Ongaku";
    };
    config = mkIf cfg.enable {
      home-manager.users.${config.jeomod.user}.home.packages = with pkgs; [ongaku];
    };
  }
