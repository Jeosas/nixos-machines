{
  lib,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.suites.social;
in
with lib;
with lib.${namespace};
{
  options.${namespace}.suites.social = {
    enable = mkEnableOption "social suite";
  };

  config = mkIf cfg.enable {
    ${namespace}.apps = {
      signal = enabled;
      vesktop = enabled;
    };
  };
}
