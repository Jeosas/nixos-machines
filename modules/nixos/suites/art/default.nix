{
  lib,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.suites.art;
in
with lib;
with lib.${namespace};
{
  options.${namespace}.suites.art = {
    enable = mkEnableOption "art suite";
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.${namespace}.user.name} = {
      ${namespace}.apps = {
        blender = enabled;
        inkscape = enabled;
        krita = enabled;
      };
    };
  };
}
