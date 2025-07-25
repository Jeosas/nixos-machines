{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.fd;
in
{
  options.${namespace}.apps.fd = {
    enable = mkEnableOption "fd";
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
        fd = {
          enable = true;
          hidden = true;
          # ignores = [];
        };
      };
    };
  };
}
