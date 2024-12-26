{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.apps.mullvad;
in
{
  options.${namespace}.apps.mullvad = with lib.types; {
    enable = mkEnableOption "Mullvad";
    enableWaylandSupport = mkOpt bool true "Enable wayland support.";
  };

  config = mkIf cfg.enable {
    ${namespace} = {
      home.extraConfig = {
        ${namespace}.apps.mullvad = { inherit (cfg) enable enableWaylandSupport; };
      };
      impermanence.userDirectories = [ ".mullvad" ];
    };
  };
}
