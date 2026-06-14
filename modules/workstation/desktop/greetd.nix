{ pkgs, lib, ... }:
{
  config = {
    services.greetd = {
      enable = true;
      settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd start-hyprland";
    };

    # Fix systemd messages appearing on login tui
    systemd.services.greetd = {
      unitConfig = {
        After = lib.mkOverride 0 [ "multi-user.target" ];
      };
      serviceConfig = {
        Type = "idle";
      };
    };
  };
}
