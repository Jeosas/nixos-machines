{
  lib,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.suites.development.gamedev;
in
with lib;
with lib.${namespace};
{
  options.${namespace}.suites.development.gamedev = {
    enable = mkEnableOption "gamedev suite";
  };

  config = mkIf cfg.enable {
    ${namespace} = { };

    home-manager.users.${config.${namespace}.user.name} = {
      ${namespace}.apps = {
        godot = enabled;
      };
    };
  };
}
