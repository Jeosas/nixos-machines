{
  lib,
  pkgs,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.cli-apps.termscp;
in
  with lib; {
    options.${namespace}.cli-apps.termscp = {enable = mkEnableOption "termscp";};

    config = mkIf cfg.enable {
      home.packages = with pkgs; [termscp];
    };
  }
