{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.btop;
in
{
  options.${namespace}.apps.btop = {
    enable = mkEnableOption "btop";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.${namespace}.user.enableHomeManager;
        message = "Home-manager is not enabled.";
      }
    ];

    home-manager.users.${config.${namespace}.user.name} = {
      programs.btop = {
        enable = true;
        settings = {
          color_theme = "nord";
          theme_background = false;
        };
      };
    };
  };
}
