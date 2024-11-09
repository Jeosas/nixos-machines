{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.jeomod.applications.mixxx;
in
  with lib; {
    options.jeomod.applications.mixxx = {
      enable = mkEnableOption "mixxx";
    };

    config = mkIf cfg.enable {
      home-manager.users.${config.jeomod.user} = {
        home.packages = with pkgs; [mixxx];
      };
      jeomod.system.impermanence.user.directories = [".mixxx"];
    };
  }
