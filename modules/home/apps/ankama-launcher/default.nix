{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.apps.ankama-launcher;
in
with lib;
{
  options.${namespace}.apps.ankama-launcher = {
    enable = mkEnableOption "Ankama Launcher";
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      with pkgs.${namespace};
      [
        ankama-launcher
        wineWowPackages.stable
      ];

    ${namespace}.impermanence.directories = [
      ".config/zaap"
      ".config/Ankama"
      ".config/Ankama Launcher"
    ];
  };
}
