{
  lib,
  namespace,
  config,
  pkgs,
  ...
}:
let
  cfg = config.${namespace}.tools.gcloud;
in
with lib;
with lib.${namespace};
{
  options.${namespace}.tools.gcloud = {
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
          CLOUDSDK_CONFIG = "$HOME/${configDir}";
        };
      };

      ${namespace}.impermanence.userDirectories = [ configDir ];
    };
}
