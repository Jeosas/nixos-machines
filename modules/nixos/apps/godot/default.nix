{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.apps.godot;
in
with lib;
{
  options.${namespace}.apps.godot = {
    enable = mkEnableOption "Godot";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ godot_4 ];
    ${namespace}.impermanence.userDirectories = [ ".config/godot" ];
  };
}
