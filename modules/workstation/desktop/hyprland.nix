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
        packages =
          with pkgs;
          let
            iconCfg = config.${namespace}.theme.icon;
            iconPath = "${iconCfg.package}/share/icons/${iconCfg.name}/status/scalable";

            brightnessctl = callPackage ./scripts/brightnessctl.nix { inherit iconPath; };
            volumectl = callPackage ./scripts/volumectl.nix { inherit iconPath; };
            launchbar = callPackage ./scripts/launchbar.nix { };
          in
          [
            wl-clipboard
            hyprshot
            playerctl

            brightnessctl
            volumectl
            launchbar
          ];
      };
    };
  };
}
