{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options = {
    jeomod.theme = {
      colors = let
        mkColorOption = name: {
          inherit name;
          value = mkOption {
            type = types.strMatching "#[a-fA-F0-9]{6}";
            description = "Color ${name}.";
          };
        };
      in
        listToAttrs (map mkColorOption [
          "background"
          "foreground"
          "cursor"
          "color0"
          "color1"
          "color2"
          "color3"
          "color4"
          "color5"
          "color6"
          "color7"
          "color8"
          "color9"
          "color10"
          "color11"
          "color12"
          "color13"
          "color14"
          "color15"
        ]);
      fonts = {
        sans = mkOption {
          type = types.str;
          description = "Sans normal font";
        };
        mono = mkOption {
          type = types.str;
          description = "Monospace font";
        };
      };
    };
  };

  config = {
    fonts.enableDefaultPackages = false; # leave home-manager setup fonts

    home-manager.users.${config.jeomod.user} = {
      fonts.fontconfig.enable = true;

      home = {
        packages = with pkgs; [
          # Fonts
          mplus-outline-fonts.githubRelease # normal + cjk font
          openmoji-color # emoji
          (nerdfonts.override {fonts = ["MPlus"];}) # nerdfonts

          # Windaube fonts for compat
          corefonts
          vistafonts

          # Cursor
          nordzy-cursor-theme
        ];

        pointerCursor = {
          gtk.enable = true;
          package = pkgs.nordzy-cursor-theme;
          name = "Nordzy-cursors";
          size = 24;
        };
      };

      gtk = {
        enable = true;
        font = {
          name = config.jeomod.theme.fonts.sans;
          size = 11;
        };
        iconTheme = {
          package = pkgs.nordzy-icon-theme;
          name = "Nordzy-dark";
        };
        theme = {
          package = pkgs.nordic;
          name = "Nordic";
        };
        gtk3 = {
          extraCss =
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
  };
}
