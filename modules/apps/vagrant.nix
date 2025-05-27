{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.vagrant;
in
{
  options.${namespace}.apps.vagrant = {
    enable = mkEnableOption "vagrant";
  };

  config =
    let
      configDir = ".config/vagrant";
    in
    mkIf cfg.enable {
      environment = {
        systemPackages = with pkgs; [ vagrant ];
        sessionVariables = {
          VAGRANT_HOME = "$HOME/${configDir}";
        };
      };

      ${namespace}.impermanence.userDirectories = [ configDir ];
    };
}
