{
  lib,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.suites.music;
in
  with lib;
  with lib.${namespace}; {
    options.${namespace}.suites.music = {enable = mkEnableOption "music suite";};

    config = mkIf cfg.enable {
      home-manager.users.${config.${namespace}.user.name} = {
        ${namespace}.cli-apps = {
          ongaku = enabled;
        };
      };
    };
  }
