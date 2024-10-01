{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.jeomod.applications.transmission;
in
  with lib; {
    options.jeomod.applications.transmission = {
      enable = mkEnableOption "Transmission";
    };

    config = mkIf cfg.enable {
      home-manager.users.${config.jeomod.user}.home.packages = with pkgs; [transmission_4-gtk];
      jeomod.system.impermanence.user.directories = [".config/transmission"];
    };
  }
