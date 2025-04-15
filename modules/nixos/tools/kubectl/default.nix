{
  lib,
  namespace,
  config,
  pkgs,
  ...
}:
let
  cfg = config.${namespace}.tools.kubectl;
in
with lib;
with lib.${namespace};
{
  options.${namespace}.tools.kubectl = {
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
          KUBECONFIG = "$HOME/${configDir}";
        };
      };

      ${namespace}.impermanence.userDirectories = [ configDir ];
    };
}
