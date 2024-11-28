{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.theme.cursor;
in {
  options.${namespace}.theme.cursor = with types; {
    enable = mkEnableOption "cursor";
    cursor = {
      name = mkOpt str "Nordzy-cursors" "The name of the cursor theme to apply.";
      package = mkOpt package pkgs.nordzy-cursor-theme "The package to use for the cursor theme.";
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${config.${namespace}.user.name} = {
      home = {
        packages = [
          cfg.cursor.package
        ];

        pointerCursor = {
          inherit (cfg.cursor) name package;
          size = 24;

          gtk.enable = config.${namespace}.theme.gtk.enable;
        };
      };
    };
  };
}
