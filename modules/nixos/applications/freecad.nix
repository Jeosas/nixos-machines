{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.jeomod.applications.freecad;
in
  with lib; {
    options.jeomod.applications.freecad = {
      enable = mkEnableOption "FreeCAD";
    };

    config = mkIf cfg.enable {
      home-manager.users.${config.jeomod.user}.home = {
        packages = with pkgs; [freecad];
      };

      jeomod.system.impermanence.user.directories = [
        ".config/FreeCAD"
      ];
    };
  }
