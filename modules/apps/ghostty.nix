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
          font-family = "${config.${namespace}.theme.fonts.mono.name}";
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
            inherit (colors) background foreground;
            cursor-color = colors.cursor;
            palette = [
              "0=${colors.color0}"
              "1=${colors.color1}"
              "2=${colors.color2}"
              "3=${colors.color3}"
              "4=${colors.color4}"
              "5=${colors.color5}"
              "6=${colors.color6}"
              "7=${colors.color7}"
              "8=${colors.color8}"
              "9=${colors.color9}"
              "10=${colors.color10}"
              "11=${colors.color11}"
              "12=${colors.color12}"
              "13=${colors.color13}"
              "14=${colors.color14}"
              "15=${colors.color15}"
            ];
            selection-background = colors.cursor;
            selection-foreground = colors.background;
          };
        };
      };
    };
  };
}
