{
  pkgs,
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (config.${namespace}.theme) wallpaper;
in
{
  config = {
    environment.systemPackages = [
      pkgs.noctalia-shell
    ];

    services.upower = {
      enable = true;
    };

    home-manager.users.${config.${namespace}.user.name} = {
      home.file."Pictures/Wallpapers/default.jpg" = {
        source = wallpaper;
      };

      xdg.configFile."noctalia" = {
        source = ./config;
        recursive = true;
      };
    };

    ${namespace}.workstation.desktop.hyprland.exec = [
      (lib.getExe pkgs.noctalia-shell)
    ];
  };
}
