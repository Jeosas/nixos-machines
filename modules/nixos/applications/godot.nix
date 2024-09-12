{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.jeomod.applications.godot;
in
  with lib; {
    options.jeomod.applications.godot = {
      enable = mkEnableOption "Godot";
    };

    config = mkIf cfg.enable {
      home-manager.users.${config.jeomod.user}.home.packages = with pkgs; [godot_4];
      jeomod.system.impermanence.user.directories = [".config/godot"];
    };
  }
