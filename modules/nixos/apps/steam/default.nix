{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.apps.steam;
in
with lib;
{
  options.${namespace}.apps.steam = {
    enable = mkEnableOption "Steam";
  };

  config = mkIf cfg.enable {
    programs.steam.enable = true;

    home-manager.users.${config.${namespace}.user.name} = {
      home.packages = with pkgs; [ protonup-ng ];

      ${namespace}.impermanence.directories = [
        ".steam"
        ".local/share/Steam"
      ];
    };
  };
}
