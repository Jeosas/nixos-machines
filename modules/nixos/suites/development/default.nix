{
  lib,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.suites.development;
in
  with lib;
  with lib.${namespace}; {
    options.${namespace}.suites.development = {enable = mkEnableOption "development suite";};

    config = mkIf cfg.enable {
      ${namespace} = {
        virtualisation = {
          docker = enabled;
          qemu = enabled;
        };
      };

      home-manager.users.${config.${namespace}.user.name} = {
        ${namespace}.tools = {
          direnv = enabled;
        };
      };
    };
  }
