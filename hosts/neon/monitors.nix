{config, ...}: {
  home-manager.users.${config.jeomod.user}.wayland.windowManager.hyprland.extraConfig = ''
    monitor=,3440x1440@144,auto,1
  '';
}
