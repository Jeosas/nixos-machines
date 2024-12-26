{
  lib,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.tools.bat;
in
with lib;
with lib.${namespace};
{
  options.${namespace}.tools.bat = {
    enable = mkEnableOption "bat";
  };

  config = mkIf cfg.enable {
    programs.bat = {
      enable = true;
      config = {
        theme = "Nord";
      };
    };
  };
}
