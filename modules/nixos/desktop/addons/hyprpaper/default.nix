{
  lib,
  namespace,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.desktop.addons.hyprpaper;

  username = config.${namespace}.user.name;
  wallpaper-path = "/home/${username}/Pictures/wallpaper.jpg";
in {
  options.${namespace}.desktop.addons.hyprpaper = with lib.types; {
    enable = mkEnableOption "hyprpaper";
    wallpaper = mkOpt path ./wallpaper.jpg "Wallpaper file.";
  };

  config = mkIf cfg.enable {
    ${namespace}.desktop.hyprland.config.exec = [
      "systemctl --user restart hyprpaper"
    ];

    home-manager.users.${username} = {
      home.file = {
        "Pictures/wallpaper.jpg" = {
          source = cfg.wallpaper;
        };
      };

      services.hyprpaper = {
        enable = true;
        settings = {
          preload = [wallpaper-path];
          wallpaper = ",${wallpaper-path}";
        };
      };
    };
  };
}
