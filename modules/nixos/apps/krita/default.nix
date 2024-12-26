{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.apps.krita;
in
with lib;
{
  options.${namespace}.apps.krita = {
    enable = mkEnableOption "Krita";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ krita ]; };
}
