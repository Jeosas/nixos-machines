{
  lib,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.suites.music.dj;
in
with lib;
with lib.${namespace};
{
  options.${namespace}.suites.music.dj = {
    enable = mkEnableOption "dj suite";
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.${namespace}.user.name} = {
      ${namespace}.apps = {
        mixxx = enabled;
      };
    };
  };
}