{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.workstation.desktop.swaywm;
in
{
  options.${namespace}.workstation.desktop.swaywm = with lib.types; {
    hostConfigGroup = mkOpt (nullOr str) null "The stow package containing host specific configs";
  };

  config = {
    programs.sway = {
      enable = true;
      xwayland.enable = true;
      wrapperFeatures.gtk = true;
    };

    # Wayland support for Electron/Chromium apps
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    ${namespace} = {
      apps.stow.groups = lib.mkMerge [
        [ "swaywm" ]
        (lib.mkIf (cfg.hostConfigGroup != null) [ cfg.hostConfigGroup ])
      ];
    };

    environment.persistence.main = {
      users.${config.${namespace}.user.name}.directories = [
        ".config/sway"
      ];
    };

    environment.systemPackages =
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
        autotiling

        brightnessctl
        volumectl
        launchbar
      ];
  };
}
