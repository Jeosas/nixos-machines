{
  lib,
  pkgs,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.virtualisation.vagrant;
in
  with lib; {
    options.${namespace}.virtualisation.vagrant = {
      enable = mkEnableOption "Vagrant";
    };

    config = mkIf cfg.enable {
      environment.systemPackages = with pkgs; [vagrant];

      home-manager.users.${config.${namespace}.user.name} = {
        ${namespace}.impermanence.directories = [".vagrant.d"];
      };
    };
  }
