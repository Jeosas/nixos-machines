{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.jeomod.applications.signal;
in
  with lib; {
    options.jeomod.applications.signal = {
      enable = mkEnableOption "Signal";
    };

    config = mkIf cfg.enable {
      home-manager.users.${config.jeomod.user}.home.packages = with pkgs; [signal-desktop];
      jeomod.system.impermanence.user.directories = [".config/Signal"];
    };
  }
