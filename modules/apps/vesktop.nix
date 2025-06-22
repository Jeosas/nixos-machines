{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.vesktop;
in
{
  options.${namespace}.apps.vesktop = {
    enable = mkEnableOption "Vesktop";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ vesktop ];

    environment.persistence.main.users.${config.${namespace}.user.name}.directories = [
      ".config/vesktop"
    ];
  };
}
