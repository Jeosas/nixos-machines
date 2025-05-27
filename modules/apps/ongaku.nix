{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.ongaku;
in
with lib;
{
  options.${namespace}.apps.ongaku = {
    enable = mkEnableOption "Ongaku";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.${namespace}.user.enableHomeManager;
        message = "Home-manager is not enabled.";
      }
    ];

    home-manager.users.${config.${namespace}.user.name} = {
      home.packages = with pkgs.${namespace}; [ ongaku ];
    };
  };
}
