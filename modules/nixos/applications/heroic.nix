{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.jeomod.applications.heroic;
in
  with lib; {
    options.jeomod.applications.heroic = {
      enable = mkEnableOption "Heroic";
    };

    config = mkIf cfg.enable {
      home-manager.users.${config.jeomod.user}.home.packages = with pkgs; [heroic];
      jeomod.system.impermanence.user.directories = [".config/heroic"];
    };
  }
