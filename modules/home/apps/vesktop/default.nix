{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.apps.vesktop;
in
with lib;
{
  options.${namespace}.apps.vesktop = {
    enable = mkEnableOption "Vesktop";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ vesktop ];

    ${namespace}.impermanence.directories = [ ".config/vesktop" ];
  };
}
