{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.jeomod.applications.mullvad;
in
  with lib; {
    options.jeomod.applications.mullvad = {
      enable = mkEnableOption "Mullvad";
    };
    config = mkIf cfg.enable {
      home-manager.users.${config.jeomod.user}.home = {
        packages = with pkgs; [mullvad-browser];

        sessionVariables = mkIf config.jeomod.desktop.hyprland.enable {
          MOZ_ENABLE_WAYLAND = "1";
        };
      };
      jeomod.system.impermanence.user.directories = [".mullvad"];
    };
  }
