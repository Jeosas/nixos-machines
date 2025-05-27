{
  namespace,
  config,
  ...
}:
let
  inherit (config.${namespace}.theme) wallpaper;
in
{
  config = {
    ${namespace}.workstation.desktop.hyprland.exec = [ "systemctl --user restart hyprpaper" ];

    home-manager.users.${config.${namespace}.user.name} = {
      services.hyprpaper = {
        enable = true;
        settings = {
          preload = [ "${wallpaper}" ];
          wallpaper = ",${wallpaper}";
          ipc = false;
        };
      };
    };
  };
}
