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
    home = {
      packages = with pkgs.${namespace}; [ zen-browser ];

      sessionVariables = {
        MOZ_ENABLE_WAYLAND = "1";
      };
    };
  };
}
