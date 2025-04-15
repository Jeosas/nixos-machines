{
  lib,
  namespace,
  config,
  pkgs,
  ...
}:
let
  cfg = config.${namespace}.tools.azure;
in
with lib;
with lib.${namespace};
{
  options.${namespace}.tools.azure = {
    enable = mkEnableOption "azure";
  };

  config =
    let
      configDir = ".config/azure";
    in
    mkIf cfg.enable {
      environment = {
        systemPackages = with pkgs; [ azure-cli ];
        sessionVariables = {
          AZURE_CONFIG_DIR = "$HOME/${configDir}";
        };
      };

      ${namespace}.impermanence.userDirectories = [ configDir ];
    };
}
