{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.signal;
in
{
  options.${namespace}.apps.signal = {
    enable = mkEnableOption "Signal";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ signal-desktop ];

    environment.persistence.main.users.${config.${namespace}.user.name}.directories = [
      ".config/Signal"
    ];
  };
}
