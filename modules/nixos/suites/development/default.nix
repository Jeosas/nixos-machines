{
  lib,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.suites.development;
in
with lib;
with lib.${namespace};
{
  options.${namespace}.suites.development = {
    enable = mkEnableOption "development suite";
  };

  config = mkIf cfg.enable {
    ${namespace} = {
      virtualisation = {
        docker = enabled;
        qemu = enabled;
      };
      tools = {
        direnv = enabled;
      };
    };

  };
}
