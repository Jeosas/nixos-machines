{
  config,
  lib,
  ...
}: let
  cfg = config.jeomod.applications.docker;
in
  with lib; {
    options.jeomod.applications.docker = {
      enable = mkEnableOption "Docker";
    };

    config = mkIf cfg.enable {
      virtualisation.docker = {
        enable = true;
        rootless = {
          enable = true;
          setSocketVariable = true;
        };
      };

      jeomod.system.impermanence = {
        directories = ["/var/lib/docker"];
        user.directories = [".config/docker"];
      };
    };
  }
