{
  lib,
  namespace,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.kubectl;

  inherit (config.home-manager.users.${config.${namespace}.user.name}.home) homeDirectory;
in
{
  options.${namespace}.apps.kubectl = {
    enable = mkEnableOption "kubectl";
  };

  config =
    let
      configDir = ".config/kubectl";
    in
    mkIf cfg.enable {
      environment = {
        systemPackages = with pkgs; [
          kubectl
          kubectx
          kubeval
          kubelogin
          kubernetes-helm
        ];
        sessionVariables = {
          KUBECONFIG = "${homeDirectory}/${configDir}/config";
        };
      };

      ${namespace}.impermanence.userDirectories = [ configDir ];
    };
}
