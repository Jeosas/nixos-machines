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
{
  options.${namespace}.apps.godot = {
    enable = mkEnableOption "Godot";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ godot_4 ];
    environment.persistence.main.users.${config.${namespace}.user.name}.directories = [
      ".config/godot"
    ];
  };
}
