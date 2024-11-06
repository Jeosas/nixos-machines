{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.jeomod.applications.openrazer;
in
  with lib; {
    options.jeomod.applications.openrazer = {
      enable = mkEnableOption "OpenRazer";
    };
    config = mkIf cfg.enable {
      hardware.openrazer.enable = true;
      environment.systemPackages = with pkgs; [
        openrazer-daemon
      ];
      jeomod.groups = ["openrazer"];

      home-manager.users.${config.jeomod.user}.home = {
        packages = with pkgs; [polychromatic];
      };
      # jeomod.system.impermanence.user.directories = [".mullvad"];
    };
  }
