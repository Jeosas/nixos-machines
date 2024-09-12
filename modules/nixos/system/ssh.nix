{
  config,
  lib,
  ...
}: let
  cfg = config.jeomod.system.ssh;
in
  with lib; {
    options.jeomod.system.ssh = {
      user = {
        config = mkOption {
          type = types.attrs;
          description = "user ssh config";
          default = {};
        };
      };
    };

    config = {
      home-manager.users.${config.jeomod.user}.programs.ssh = {
        enable = true;
        addKeysToAgent = "yes";
        matchBlocks = cfg.user.config;
      };
    };
  }
