{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.apps.blender;
in
{
  options.${namespace}.apps.blender = {
    enable = mkEnableOption "Blender";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ blender ];
    ${namespace}.impermanence.userDirectories = [ ".config/blender" ];
  };
}
