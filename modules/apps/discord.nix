{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.discord;
in
{
  options.${namespace}.apps.discord = {
    enable = mkEnableOption "Discord";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      discord
      arrpc
    ];

    systemd.packages = with pkgs; [ arrpc ];

    environment.persistence.main.users.${config.${namespace}.user.name}.directories = [
      ".config/discord"
    ];
  };
}
