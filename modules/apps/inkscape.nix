{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.inkscape;
in
{
  options.${namespace}.apps.inkscape = {
    enable = mkEnableOption "inkscape";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ inkscape ]; };
}
