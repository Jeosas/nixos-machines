{
  lib,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.cli-apps.home-manager;
in {
  options.${namespace}.cli-apps.home-manager.enable =
    mkEnableOption "Enable home-manager and its extras.";

  config = mkIf cfg.enable {programs.home-manager = enabled;};
}
