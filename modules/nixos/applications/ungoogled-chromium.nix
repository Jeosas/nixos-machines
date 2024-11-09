{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.jeomod.applications.ungoogled-chromium;
in
  with lib; {
    options.jeomod.applications.ungoogled-chromium = {
      enable = mkEnableOption "ungoogled-chromium";
    };

    config = mkIf cfg.enable {
      home-manager.users.${config.jeomod.user}.home.packages = with pkgs; [ungoogled-chromium];
    };
  }
