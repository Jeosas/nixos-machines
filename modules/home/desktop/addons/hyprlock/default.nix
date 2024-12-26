{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkForce;

  cfg = config.${namespace}.desktop.addons.hyprlock;
in
{
  options.${namespace}.desktop.addons.hyprlock = {
    enable = mkEnableOption "hyprlock";
  };

  config = mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
      settings = with config.${namespace}.theme; {
        general = {
          hide_cursor = true;
        };

        background = mkForce [
          {
            monitor = ""; # all monitors
            path = "screenshot";

            blur_passes = 1; # 0 disables blurring
          }
        ];

        label = [
          # Time
          {
            monitor = "";
            text = ''cmd[update:1000] echo "<span>$(date +"%H:%M")</span>"'';
            color = "rgba(216, 222, 233, 0.70)";
            font_size = 130;
            font_family = fonts.mono.name;
            position = "0, 240";
            halign = "center";
            valign = "center";
          }

          # Day-Month-Date
          {
            monitor = "";
            text = ''cmd[update:1000] echo -e "$(date +"%A, %d %B")"'';
            color = "rgba(216, 222, 233, 0.70)";
            font_size = 30;
            font_family = fonts.sans.name;
            position = "0, 105";
            halign = "center";
            valign = "center";
          }
        ];

        input-field = {
          monitor = "";
          size = "250, 60";
          outline_thickness = 2;
          dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
          outer_color = "rgba(0, 0, 0, 0)";
          inner_color = "rgba(100, 114, 125, 0.4)";
          font_color = "rgb(200, 200, 200)";
          fade_on_empty = false;
          font_family = fonts.sans.name;
          placeholder_text = "<i>Enter Password</i>";
          hide_input = false;
          position = "0, -150";
          halign = "center";
          valign = "center";
        };
      };
    };
  };
}
