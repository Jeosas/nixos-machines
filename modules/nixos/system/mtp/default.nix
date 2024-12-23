{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.${namespace}.system.mtp;
in
{
  options.${namespace}.system.mtp = {
    enable = mkEnableOption "mtp mount support";
  };
  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ jmtpfs ]; };
}
