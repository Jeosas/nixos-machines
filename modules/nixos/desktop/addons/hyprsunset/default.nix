{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.desktop.addons.hyprsunset;
in
{
  options.${namespace}.desktop.addons.hyprsunset = {
    enable = mkEnableOption "hyprpaper";
  };

  config = mkIf cfg.enable {
    # TODO come back when auto day cycle has been implemented
    ${namespace}.desktop.hyprland.config.exec-once = [ "hyprsunset &" ];

    home-manager.users.${config.${namespace}.user.name} = {
      home.packages = with pkgs; [ hyprsunset ];
    };
  };
}
