{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.jeomod.applications.wootility;
in
  with lib; {
    options.jeomod.applications.wootility = {
      enable = mkEnableOption "Wootility";
    };

    config = mkIf cfg.enable {
      home-manager.users.${config.jeomod.user}.home.packages = [pkgs.wootility];
      services.udev.packages = [pkgs.wooting-udev-rules];
      jeomod.groups = ["input"];
    };
  }
