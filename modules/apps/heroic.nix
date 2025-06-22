{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.heroic;
in
{
  options.${namespace}.apps.heroic = {
    enable = mkEnableOption "Heroic";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ heroic ];

    environment.persistence.main.users.${config.${namespace}.user.name}.directories = [
      ".config/heroic"
    ];
  };
}
