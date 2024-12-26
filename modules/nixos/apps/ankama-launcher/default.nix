{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.apps.ankama-launcher;
in
{
  options.${namespace}.apps.ankama-launcher = {
    enable = mkEnableOption "Ankama Launcher";
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      with pkgs.${namespace};
      [
        ankama-launcher
        wineWowPackages.stable
      ];

    ${namespace}.impermanence.userDirectories = [
      ".config/zaap"
      ".config/Ankama"
      ".config/Ankama Launcher"
    ];
  };
}