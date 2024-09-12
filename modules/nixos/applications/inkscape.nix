{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.jeomod.applications.inkscape;
in
  with lib; {
    options.jeomod.applications.inkscape = {
      enable = mkEnableOption "inkscape";
    };

    config = mkIf cfg.enable {
      home-manager.users.${config.jeomod.user}.home.packages = with pkgs; [inkscape];
    };
  }
