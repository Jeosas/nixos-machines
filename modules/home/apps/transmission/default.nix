{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.apps.transmission;
in
with lib;
{
  options.${namespace}.apps.transmission = {
    enable = mkEnableOption "Transmission";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ transmission_4-gtk ];

    ${namespace}.impermanence.directories = [ ".config/transmission" ];
  };
}
