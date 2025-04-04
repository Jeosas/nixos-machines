{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.apps.freetube;
in
{
  options.${namespace}.apps.freetube = {
    enable = mkEnableOption "Freetube";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ freetube ];
    ${namespace}.impermanence.userDirectories = [ ".config/FreeTube" ];
  };
}
