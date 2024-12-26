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
    environment.systemPackages = with pkgs; [ vesktop ];

    ${namespace}.impermanence.userDirectories = [ ".config/vesktop" ];
  };
}
