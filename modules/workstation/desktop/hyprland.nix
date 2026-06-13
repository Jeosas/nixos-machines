{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib.${namespace}) mkOpt;

  userName = config.${namespace}.user.name;

  cfg = config.${namespace}.workstation.desktop.hyprland;
in
{
  options.${namespace}.workstation.desktop.hyprland = with lib.types; {
    hostConfigGroup = mkOpt (nullOr str) null "The stow package containing host specific configs";
    exec = mkOpt (listOf str) [ ] "List of process to run on load.";
    exec-once = mkOpt (listOf str) [ ] "List process to run at startup.";
  };

  config = {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    # Wayland support for Electron/Chromium apps
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    ${namespace} = {
      apps.stow.groups = lib.mkMerge [
        [ "hyprland" ]
        (lib.mkIf (cfg.hostConfigGroup != null) [ cfg.hostConfigGroup ])
      ];
    };

    home-manager.users.${userName} = {
      home = {
        packages = with pkgs; [
          wl-clipboard
          hyprshot
        ];
      };
    };
  };
}
