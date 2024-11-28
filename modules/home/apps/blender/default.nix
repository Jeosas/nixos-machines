{
  lib,
  pkgs,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.apps.blender;
in
  with lib; {
    options.${namespace}.apps.blender = {enable = mkEnableOption "Blender";};

    config = mkIf cfg.enable {
      home.packages = with pkgs; [blender];

      ${namespace}.impermanence.directories = [".config/blender"];
    };
  }
