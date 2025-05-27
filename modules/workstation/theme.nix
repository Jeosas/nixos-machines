{
  namespace,
  config,
  ...
}:
let
  inherit (config.${namespace}) theme;
in
{
  config = {
    home-manager.users.${config.${namespace}.user.name} = {
      home = {
        packages = [ theme.cursor.package ];

        pointerCursor = {
          inherit (theme.cursor) name package;
          size = 24;

          gtk.enable = true;
          # hyprcursor.enable = true; # TODO available only in 25.05
        };

        sessionVariables = {
          # hack - similar to hyprcursor.enable = true;
          HYPRCURSOR_THEME = theme.cursor.hypr-name;
          HYPRCURSOR_SIZE = 24;
        };
      };

      gtk = {
        enable = true;
        iconTheme = { inherit (theme.icon) name package; };
        theme = { inherit (theme.theme) name package; };
        gtk3.extraCss =
          # css
          ''
            /* Remove dotted lines from GTK+ 3 applications */
            undershoot.top, undershoot.right, undershoot.bottom, undershoot.left { background-image: none; }
          '';
      };
    };
  };
}
