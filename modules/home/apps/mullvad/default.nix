{
  lib,
  pkgs,
  namespace,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.apps.mullvad;
in {
  options.${namespace}.apps.mullvad = with lib.types; {
    enable = mkEnableOption "Mullvad";
    enableWaylandSupport = mkOpt bool true "Enable wayland support.";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [mullvad-browser];

      sessionVariables = mkIf cfg.enableWaylandSupport {
        MOZ_ENABLE_WAYLAND = "1";
      };
    };

    ${namespace}.impermanence.directories = [".mullvad"];
  };
}
