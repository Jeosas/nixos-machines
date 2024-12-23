{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.apps.godot;
in
with lib;
{
  options.${namespace}.apps.godot = {
    enable = mkEnableOption "Godot";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ godot_4 ];

    ${namespace}.impermanence.directories = [ ".config/godot" ];
  };
}
