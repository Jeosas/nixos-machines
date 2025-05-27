{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.xournal;
in
{
  options.${namespace}.apps.xournal = {
    enable = mkEnableOption "xournal pdf editor";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ xournalpp ]; };
}
