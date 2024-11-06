{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.jeomod.applications.qemu;
in
  with lib; {
    options.jeomod.applications.qemu = {
      enable = mkEnableOption "Qemu";
    };

    config = mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        qemu
        quickemu
      ];
      jeomod.system.impermanence.user.directories = ["vm"];
    };
  }
