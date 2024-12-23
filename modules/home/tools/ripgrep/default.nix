{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.tools.ripgrep;
in
with lib;
with lib.${namespace};
{
  options.${namespace}.tools.ripgrep = {
    enable = mkEnableOption "ripgrep";
  };
  config = mkIf cfg.enable { home.packages = with pkgs; [ ripgrep ]; };
}
