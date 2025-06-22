{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.mixxx;
in
{
  options.${namespace}.apps.mixxx = {
    enable = mkEnableOption "mixxx";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ mixxx ];
    environment.persistence.main.users.${config.${namespace}.user.name}.directories = [
      ".mixxx"
    ];
  };
}
