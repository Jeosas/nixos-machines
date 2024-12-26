{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.tools.direnv;
in
{
  options.${namespace}.tools.direnv = {
    enable = mkEnableOption "direnv";
  };

  config = mkIf cfg.enable {
    ${namespace} = {
      home.extraConfig = {
        ${namespace}.tools.direnv = enabled;
      };

      impermanence.userDirectories = [ ".local/share/direnv/allow" ];
    };
  };
}
