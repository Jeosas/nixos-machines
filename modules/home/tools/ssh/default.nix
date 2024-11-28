{
  lib,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.tools.ssh;
in
  with lib;
  with lib.${namespace}; {
    options.${namespace}.tools.ssh = with types; {
      enable = mkEnableOption "ssh";
      user = {
        config = mkOpt attrs {} "user ssh config";
      };
    };

    config = mkIf cfg.enable {
      programs.ssh = {
        enable = true;
        addKeysToAgent = "yes";
        matchBlocks = cfg.user.config;
      };
    };
  }
