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

    environment.systemPackages = with pkgs; [ protonup-ng ];

    ${namespace}.impermanence.userDirectories = [
      ".steam"
      ".local/share/Steam"
    ];
  };
}
