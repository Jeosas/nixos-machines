{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.jeomod.applications.blender;
in
  with lib; {
    options.jeomod.applications.blender = {
      enable = mkEnableOption "Blender";
    };

    config = mkIf cfg.enable {
      home-manager.users.${config.jeomod.user}.home.packages = with pkgs; [blender];
      jeomod.system.impermanence.user.directories = [".config/blender"];
    };
  }
