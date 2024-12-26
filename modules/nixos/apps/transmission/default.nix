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
    environment.systemPackages = with pkgs; [ transmission_4-gtk ];

    ${namespace}.impermanence.userDirectories = [ ".config/transmission" ];
  };
}
