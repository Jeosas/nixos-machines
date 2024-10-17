{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.jeomod.applications.vesktop;
in
  with lib; {
    options.jeomod.applications.vesktop = {
      enable = mkEnableOption "Vesktop";
    };

    config = mkIf cfg.enable {
      home-manager.users.${config.jeomod.user}.home.packages = with pkgs; [vesktop];
      jeomod.system.impermanence.user.directories = [".config/vesktop"];
    };
  }
