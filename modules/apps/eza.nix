{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.eza;
in
{
  options.${namespace}.apps.eza = {
    enable = mkEnableOption "eza";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.${namespace}.user.enableHomeManager;
        message = "Home-manager is not enabled.";
      }
    ];

    home-manager.users.${config.${namespace}.user.name} = {
      programs = {
        eza = {
          enable = true;
          enableBashIntegration = config.${namespace}.apps.bash.enable;
          colors = "auto";
          icons = "auto";
          git = true;
        };
      };
    };
  };
}
