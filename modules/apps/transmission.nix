{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.transmission;
in
{
  options.${namespace}.apps.transmission = {
    enable = mkEnableOption "Transmission";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ transmission_4-gtk ];

    ${namespace}.impermanence.userDirectories = [ ".config/transmission" ];
  };
}
