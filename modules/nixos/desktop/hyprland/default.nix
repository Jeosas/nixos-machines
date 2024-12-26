{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkOpt enabled;

  cfg = config.${namespace}.desktop.hyprland;
in
{
  options.${namespace}.desktop.hyprland = with lib.types; {
    enable = mkEnableOption "Hyprland custom";
    config = mkOpt (attrsOf anything) { } "Hyprland config options.";
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    ${namespace} = {
      desktop.addons = {
        hyprlock = enabled;
      };

      home.extraConfig = {
        ${namespace}.desktop.hyprland = {
          inherit (cfg) enable config;
        };
      };
    };
  };
}
