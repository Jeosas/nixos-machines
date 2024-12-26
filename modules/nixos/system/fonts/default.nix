{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.system.fonts;
in
{
  options.${namespace}.system.fonts = with types; {
    enable = mkEnableOption "fonts";
    fonts = mkOpt (listOf package) [ ] "Custom font packages to install.";
  };
  config = mkIf cfg.enable {
    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };

    environment.variables = {
      # Enable icons in tooling since we have nerdfonts.
      LOG_ICONS = "true";
    };

    # Required for Home Manager's GTK settings to work
    programs.dconf.enable = true;

    fonts = {
      packages =
        with pkgs;
        with config.${namespace}.theme.fonts;
        [
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif

          # Windaube fonts for compat
          corefonts
          vistafonts

          # Theme
          sans.package
          mono.package
          emoji.package
        ]
        ++ cfg.fonts;

      fontconfig = {
        enable = true;
        useEmbeddedBitmaps = true;
        defaultFonts = with config.${namespace}.theme.fonts; {
          monospace = [ mono.name ];
          serif = [ sans.name ];
          sansSerif = [ sans.name ];
          emoji = [ emoji.name ];
        };
      };
    };
  };
}
