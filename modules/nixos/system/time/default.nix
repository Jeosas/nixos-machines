{
  lib,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.system.time;
in {
  options.${namespace}.system.time = {enable = mkEnableOption "time";};
  config = mkIf cfg.enable {time.timeZone = "Europe/Paris";};
}
