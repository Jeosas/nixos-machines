{
  lib,
  namespace,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.gcloud;

  inherit (config.home-manager.users.${config.${namespace}.user.name}.home) homeDirectory;
in
{
  options.${namespace}.apps.gcloud = {
    enable = mkEnableOption "gcloud";
  };

  config =
    let
      gcloud = pkgs.google-cloud-sdk.withExtraComponents (
        with pkgs.google-cloud-sdk.components;
        [
          gke-gcloud-auth-plugin
        ]
      );
      configDir = ".config/gcloud";
    in
    mkIf cfg.enable {
      environment = {
        systemPackages = [ gcloud ];
        sessionVariables = {
          CLOUDSDK_CONFIG = "${homeDirectory}/${configDir}";
        };
      };

      ${namespace}.impermanence.userDirectories = [ configDir ];
    };
}
