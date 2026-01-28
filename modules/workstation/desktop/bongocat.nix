{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.workstation.desktop.bongocat;
in
{
  options.${namespace}.workstation.desktop.bongocat = with lib.types; {
    enable = mkEnableOption "bongocat";
    keyboard_device = mkOpt str "" "kbd event path (e.g. /lib/input/event5)";
    monitor = mkOpt str "auto" "monitor where to house the bongocat";
  };

  config = mkIf cfg.enable {
    ${namespace}.workstation.desktop.hyprland.exec-once = with pkgs.${namespace}; [
      "${(bongocat.override { inherit (cfg) keyboard_device monitor; })}/bin/bongocat"
    ];
  };
}
