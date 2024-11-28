{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.theme.fonts;
in {
  options.${namespace}.theme.fonts = with types; {
    sans = mkOpt str "M+1Code Nerd Font" "Default sans font";
    mono = mkOpt str "M+1Code Nerd Font Mono" "Default monospace font";
    extraFontPackages = mkOpt (listOf package) [(pkgs.nerdfonts.override {fonts = ["MPlus"];})] "List of extra font packages";
    # NOTE: becomes `nerd-fonts.mplus` in 25.05
  };

  config = {
    fonts.packages = cfg.extraFontPackages;
  };
}
