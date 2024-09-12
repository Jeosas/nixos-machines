{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.jeomod.applications.steam;
in
  with lib; {
    options.jeomod.applications.steam = {
      enable = mkEnableOption "Steam";
    };

    config = mkIf cfg.enable {
      programs.steam.enable = true;
      home-manager.users.${config.jeomod.user}.home.packages = with pkgs; [protonup-ng];
      jeomod.system.impermanence.user.directories = [
        ".steam"
        ".local/share/Steam"
      ];
    };
  }
