{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.steam;
in
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
