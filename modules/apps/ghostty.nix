{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.ghostty;
in
{
  options.${namespace}.apps.ghostty = {
    enable = mkEnableOption "ghostty";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.${namespace}.user.enableHomeManager;
        message = "Home-manager is not enabled.";
      }
    ];

    home-manager.users.${config.${namespace}.user.name} = {
      programs.ghostty = {
        enable = true;
        enableZshIntegration = config.${namespace}.apps.zsh.enable;
        enableBashIntegration = config.${namespace}.apps.bash.enable;

        clearDefaultKeybinds = true;
        settings = {
          theme = "custom";
          font-family = "${config.${namespace}.theme.fonts.mono.name} Regular";
          font-family-bold = "${config.${namespace}.theme.fonts.mono.name} Bold";
          font-family-italic = "${config.${namespace}.theme.fonts.mono.name} Italic";
          font-family-bold-italic = "${config.${namespace}.theme.fonts.mono.name} Bold Italic";
          font-feature = "-calt, -liga, -dlig"; # disable ligature
          font-size = 11;

          cursor-style = "block";
          shell-integration-features = "no-cursor";

          background-opacity = 0.9;
          background-blur = 1;
        };
        themes = with config.${namespace}.theme; {
          custom = {
            background = colors.color0;
            foreground = colors.color5;

            selection-background = colors.color2;
            selection-foreground = colors.color0;

            palette = [
              "0=${colors.color0}"
              "1=${colors.color8}"
              "2=${colors.color11}"
              "3=${colors.color10}"
              "4=${colors.color13}"
              "5=${colors.color14}"
              "6=${colors.color12}"
              "7=${colors.color5}"
              "8=${colors.color3}"
              "9=${colors.color8}"
              "10=${colors.color11}"
              "11=${colors.color10}"
              "12=${colors.color13}"
              "13=${colors.color14}"
              "14=${colors.color12}"
              "15=${colors.color7}"
              "16=${colors.color9}"
              "17=${colors.color15}"
              "18=${colors.color1}"
              "19=${colors.color2}"
              "20=${colors.color4}"
              "21=${colors.color6}"
            ];
          };
        };
      };
    };
  };
}
