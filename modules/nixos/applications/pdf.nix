{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.jeomod.applications.pdf;
in
  with lib; {
    options.jeomod.applications.pdf = {
      enable = mkEnableOption "pdf editor";
    };

    config = mkIf cfg.enable {
      home-manager.users.${config.jeomod.user}.home.packages = with pkgs; [xournalpp];
    };
  }
