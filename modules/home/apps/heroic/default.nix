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
    home.packages = with pkgs; [ heroic ];

    ${namespace}.impermanence.directories = [ ".config/heroic" ];
  };
}
