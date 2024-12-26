{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.apps.firefox;
in
{
  options.${namespace}.apps.firefox = with lib.types; {
    enable = mkEnableOption "Firefox";
    enableWaylandSupport = mkOpt bool true "Enable wayland support.";
  };

  config = mkIf cfg.enable {
    ${namespace} = {
      home.extraConfig = {
        ${namespace}.apps.firefox = { inherit (cfg) enable enableWaylandSupport; };
      };
      impermanence.userDirectories = [ ".mozilla/firefox/default" ];
    };
  };
}
