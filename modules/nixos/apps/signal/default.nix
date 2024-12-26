{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.apps.signal;
in
with lib;
{
  options.${namespace}.apps.signal = {
    enable = mkEnableOption "Signal";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ signal-desktop ];

    ${namespace}.impermanence.userDirectories = [ ".config/Signal" ];
  };
}
