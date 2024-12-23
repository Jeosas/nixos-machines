{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.apps.xournal;
in
with lib;
{
  options.${namespace}.apps.xournal = {
    enable = mkEnableOption "xournal pdf editor";
  };

  config = mkIf cfg.enable { home.packages = with pkgs; [ xournalpp ]; };
}
