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
    assertions = [
      {
        assertion = config.${namespace}.user.enableHomeManager;
        message = "Home-manager is not enabled.";
      }
    ];

    environment.persistence.main.users.${config.${namespace}.user.name}.directories = [
      ".mullvad"
    ];

    home-manager.users.${config.${namespace}.user.name} = {
      home = {
        packages = with pkgs; [ mullvad-browser ];

        sessionVariables = mkIf cfg.enableWaylandSupport { MOZ_ENABLE_WAYLAND = "1"; };
      };
    };
  };
}
