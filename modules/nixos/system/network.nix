{
  config,
  lib,
  ...
}: let
  cfg = config.jeomod.system.network;
in
  with lib; {
    options.jeomod.system.network = {
      hostName = mkOption {
        type = types.str;
        description = "system hostname";
      };
    };

    config = {
      networking = {
        inherit (cfg) hostName;
        networkmanager.enable = true;
        firewall.enable = true;
      };
      jeomod.groups = ["networkmanager"];
    };
  }
