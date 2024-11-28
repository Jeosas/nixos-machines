{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.theme.gtk;
in {
  options.${namespace}.theme.gtk = with types; {
    enable = mkEnableOption "gtk";
    theme = {
      name = mkOpt str "Nordic-darker" "The name of the GTK theme to apply.";
      package = mkOpt package pkgs.nordic "The package to use for the theme.";
    };
    icon = {
      name = mkOpt str "Nordzy-dark" "The name of the icon theme to apply.";
      package = mkOpt package pkgs.nordzy-icon-theme "The package to use for the icon theme.";
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${config.${namespace}.user.name} = {
      gtk = {
        enable = true;
        iconTheme = {inherit (cfg.icon) name package;};
        theme = {inherit (cfg.theme) name package;};
        gtk3.extraCss =
          /*
          css
          */
          ''
            /* Remove dotted lines from GTK+ 3 applications */
            undershoot.top, undershoot.right, undershoot.bottom, undershoot.left { background-image: none; }
          '';
      };
    };
  };
}
