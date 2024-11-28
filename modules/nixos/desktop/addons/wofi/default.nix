{
  lib,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.desktop.addons.wofi;
in {
  options.${namespace}.desktop.addons.wofi = {enable = mkEnableOption "wofi";};

  config = mkIf cfg.enable {
    home-manager.users.${config.${namespace}.user.name} = {
      programs.wofi = {
        enable = true;
        settings = {
          width = 450;
          height = 250;
          location = "center";
          show = "drun";
          prompt = "Search...";
          matching = "fuzzy";
          filter_rate = 100;
          allow_markup = true;
          no_actions = true;
          halign = "fill";
          valigh = "start";
          hide_scroll = true;
          hide_search = false;
          orientation = "vertical";
          insensitive = true;
          allow_images = true;
          image_size = 40;
          gtk_dark = true;
        };
        style = with config.${namespace}.theme;
        /*
        css
        */
          ''
            window {
              font-family: "${fonts.sans}";
              font-size: 13px;
              margin: 0px;
              padding: 0px;
              border: 2px solid ${colors.color2};
              border-radius: 6px;
            }

            #input {
              min-height: 36px;
              padding: 4px 10px;
              margin: 4px;
              border: none;
              font-weight: bold;
              outline: none;
              border-radius: 6px;
              margin: 10px;
              margin-bottom: 2px;
            }

            #outer-box {
              margin: 0px;
              padding: 8px;
              border: none;
            }

            #scroll {
              padding: 8px;
            }

            #text {
              padding: 3px;
            }

            #entry {
              margin: 3px;
              border: none;
              border-radius: 6px;
            }

            .undershoot.top {
              background-image = transparent;
            }
            .undershoot.bottom {
              background-image = transparent;
            }
          '';
      };
    };
  };
}
