{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.cli-apps.gh;
in
{
  options.${namespace}.cli-apps.gh = {
    enable = mkEnableOption "gh";
  };

  config = mkIf cfg.enable {
    programs = {
      gh = {
        enable = true;
      };
      gh-dash = {
        enable = true;
      };
    };
  };
}
