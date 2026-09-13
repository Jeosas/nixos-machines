{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.apps.tuxguitar;
in
{
  options.${namespace}.apps.tuxguitar = {
    enable = mkEnableOption "Tuxguitar";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ tuxguitar ];

    environment.persistence.main.users.${config.${namespace}.user.name}.directories = [
      ".config/tuxguitar"
    ];
  };
}
