{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.cli-apps.gh;
in
{
  options.${namespace}.cli-apps.gh = {
    enable = mkEnableOption "gh";
  };

  config = mkIf cfg.enable {
    ${namespace} = {
      home.extraConfig = {
        ${namespace}.cli-apps.gh = {
          inherit (cfg) enable;
        };
      };
      impermanence.userDirectories = [
        ".config/gh"
        # ".config/gh-dash"
      ];
    };
  };
}
