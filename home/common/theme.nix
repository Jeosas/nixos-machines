{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [../../modules/home-manager/theme.nix];

  home.packages = with pkgs; [
    # Fonts
    mplus-outline-fonts.githubRelease # normal + cjk font
    openmoji-color # emoji
    (nerdfonts.override {fonts = ["MPlus"];}) # nerdfonts

    # Cursor
    nordzy-cursor-theme
  ];

  fonts.fontconfig.enable = true;

  theme = {
    colors = {
      color0 = "#3b4252"; # nord1 - black
      color1 = "#bf616a"; # nord11 - red
      color2 = "#a3be8c"; # nord14 - green
      color3 = "#ebcb8b"; # nord13 - yellow
      color4 = "#81a1c1"; # nord9 - blue
      color5 = "#b48ead"; # nord15 - magenta
      color6 = "#88c0d0"; # nord8 - cyan
      color7 = "#eceff4"; # nord5 - white
      color8 = "#4c566a"; # nord3 - bblack
      color9 = "#bf616a"; # nord11 - bred
      color10 = "#a3be8c"; # nord14 - bgreen
      color11 = "#ebcb8b"; # nord13 - byallow
      color12 = "#81a1c1"; # nord9 - bblue
      color13 = "#b48ead"; # nord15 - bmagenta
      color14 = "#8fbcbb"; # nord7 - bcyan
      color15 = "#eceff4"; # nord6 - cwhite
      background = "#2e3440"; # nord0
      foreground = "#d8dee9"; # nord4
      cursor = "#d8dee9"; # nord4
    };

    fonts = {
      sans = "M+1Code Nerd Font";
      mono = "M+1Code Nerd Font Mono";
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.nordzy-cursor-theme;
    name = "Nordzy-cursors";
    size = 24;
  };

  gtk = {
    enable = true;
    font = {
      name = config.theme.fonts.sans;
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
}
