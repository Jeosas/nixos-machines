{
  lib,
  pkgs,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.apps.ungoogled-chromium;
in
  with lib; {
    options.${namespace}.apps.ungoogled-chromium = {enable = mkEnableOption "ungoogled-chromium";};

    config = mkIf cfg.enable {
      home.packages = with pkgs; [ungoogled-chromium];
    };
  }
