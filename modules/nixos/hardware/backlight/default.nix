{
  lib,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.hardware.backlight;
in {
  options.${namespace}.hardware.backlight = {enable = mkEnableOption "backlight";};
  config = mkIf cfg.enable {
    programs.light = enabled;
    ${namespace}.user.extraGroups = ["video"];
  };
}
