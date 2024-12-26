{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.apps.mixxx;
in
with lib;
{
  options.${namespace}.apps.mixxx = {
    enable = mkEnableOption "mixxx";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ mixxx ];
    ${namespace}.impermanence.userDirectories = [ ".mixxx" ];
  };
}
