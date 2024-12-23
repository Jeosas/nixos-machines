{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.apps.lutris;
in
with lib;
{
  options.${namespace}.apps.lutris = {
    enable = mkEnableOption "Luris";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ lutris ];

    ${namespace}.impermanence.directories = [ "local/share/lutris" ];
  };
}
