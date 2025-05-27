{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.krita;
in
{
  options.${namespace}.apps.krita = {
    enable = mkEnableOption "Krita";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ krita ]; };
}
