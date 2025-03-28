{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.cli-apps.tldr;
in
{
  options.${namespace}.cli-apps.tldr = with lib.types; {
    enable = mkEnableOption "tldr";
    cacheDir = mkOpt string ".cache/tealdeer" "tldr pages cache directory";
  };

  config = mkIf cfg.enable {
    ${namespace} = {
      home.extraConfig = {
        ${namespace}.cli-apps.tldr = {
          inherit (cfg) enable cacheDir;
        };
      };

      impermanence.userDirectories = [ cfg.cacheDir ];
    };
  };
}
