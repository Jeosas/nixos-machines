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

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ xournalpp ]; };
}
