{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.apps.heroic;
in
with lib;
{
  options.${namespace}.apps.heroic = {
    enable = mkEnableOption "Heroic";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ heroic ];

    ${namespace}.impermanence.userDirectories = [ ".config/heroic" ];
  };
}
