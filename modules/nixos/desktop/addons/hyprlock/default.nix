{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkForce;

  cfg = config.${namespace}.desktop.addons.hyprlock;
in
{
  options.${namespace}.desktop.addons.hyprlock = {
    enable = mkEnableOption "hyprlock";
  };

  config = mkIf cfg.enable {
    programs.hyprlock.enable = true;
    services.hypridle.enable = mkForce false;

    ${namespace}.home.extraConfig = {
      ${namespace}.desktop.addons.hyprlock.enable = true;
    };
  };
}
