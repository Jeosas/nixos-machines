{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.zen-browser;
in
{
  options.${namespace}.apps.zen-browser = {
    enable = mkEnableOption "Zen browser";
  };

  config = mkIf cfg.enable {
    ${namespace} = {
      home.extraConfig = {
        ${namespace}.apps.zen-browser = { inherit (cfg) enable; };
      };
      impermanence.userDirectories = [ ".zen" ];
    };
  };
}
