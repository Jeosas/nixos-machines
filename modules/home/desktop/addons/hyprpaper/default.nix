{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  wallpaper = config.${namespace}.theme.wallpaper;

  cfg = config.${namespace}.desktop.addons.hyprpaper;
in
{
  options.${namespace}.desktop.addons.hyprpaper = with lib.types; {
    enable = mkEnableOption "hyprpaper";
  };

  config = mkIf cfg.enable {
    ${namespace}.desktop.hyprland.config.exec = [ "systemctl --user restart hyprpaper" ];

    services.hyprpaper = {
      enable = true;
      settings = {
        preload = [ "${wallpaper}" ];
        wallpaper = ",${wallpaper}";
        ipc = false;
      };
    };
  };
}
