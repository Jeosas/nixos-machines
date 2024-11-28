{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.system.fonts;
in {
  options.${namespace}.system.fonts = with types; {
    enable = mkEnableOption "fonts";
    fonts = mkOpt (listOf package) [] "Custom font packages to install.";
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

    fonts = {
      packages = with pkgs;
        [
          mplus-outline-fonts.githubRelease # normal + cjk font

          (nerdfonts.override {fonts = ["MPlus"];}) # nerdfonts
          # NOTE: becomes `nerd-fonts.mplus` in 25.05

          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
          noto-fonts-emoji

          # Windaube fonts for compat
          corefonts
          vistafonts
        ]
        ++ cfg.fonts;
    };
  };
}
