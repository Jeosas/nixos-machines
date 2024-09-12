{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.jeomod.applications.discord;
in
  with lib; {
    options.jeomod.applications.discord = {
      enable = mkEnableOption "Discord";
    };

    config = mkIf cfg.enable {
      home-manager.users.${config.jeomod.user}.home.packages = with pkgs; [discord];
      jeomod.system.impermanence.user.directories = [".config/discord"];
    };
  }
