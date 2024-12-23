{
  lib,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.suites.laptop;
in
with lib;
with lib.${namespace};
{
  options.${namespace}.suites.laptop = {
    enable = mkEnableOption "laptop suite";
  };

  config = mkIf cfg.enable {
    ${namespace} = {
      hardware = {
        backlight = enabled;
      };
    };
  };
}
