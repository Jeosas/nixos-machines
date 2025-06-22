{
  lib,
  namespace,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.apps.azure;

  inherit (config.home-manager.users.${config.${namespace}.user.name}.home) homeDirectory;
in
{
  options.${namespace}.apps.azure = {
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
          AZURE_CONFIG_DIR = "${homeDirectory}/${configDir}";
        };
      };

      environment.persistence.main.users.${config.${namespace}.user.name}.directories = [
        configDir
      ];
    };
}
