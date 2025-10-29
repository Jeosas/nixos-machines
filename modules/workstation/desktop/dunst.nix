{
  namespace,
  config,
  ...
}:
{
  config = {
    ${namespace}.workstation.desktop.hyprland.exec-once = [ "dunst &" ];

    home-manager.users.${config.${namespace}.user.name} = {
      services.dunst = {
        enable = true;

        settings = with config.${namespace}.theme; {
          global = {
            # Display
            follow = "keyboard";

            # Geometry
            width = 400;
            height = 400;
            origin = "bottom-right";
            offset = "16x16";
            notification_limit = 0;

            # Progress bar
            progress_bar_height = 8;
            progress_bar_frame_width = 0;
            progress_bar_min_width = 350;
            progress_bar_max_width = 400;

            # Style
            padding = 12;
            horizontal_padding = 15;
            frame_width = 2;
            corner_radius = config.${namespace}.theme.borderRadius;
            font = "${fonts.sans.name} 11";

            # Formatting
            markup = "full";
            format = ''
              <small>%a</small>
              <b>%s %p</b>
              %b'';
            ellipsize = "end";

            # Mouse interaction
            mouse_left_click = "close_current";
            mouse_middle_click = "close_all";
            mouse_right_click = "do_action";
          };

          urgency_low = {
            timeout = 3;
            inherit (colors) background foreground;
            highlight = colors.foreground;
            frame_color = colors.color11;
          };
          urgency_normal = {
            timeout = 6;
            inherit (colors) background foreground;
            highlight = colors.foreground;
            frame_color = colors.color11;
          };
          urgency_high = {
            timeout = 0;
            inherit (colors) background foreground;
            highlight = colors.foreground;
            frame_color = colors.color8;
          };
        };
      };
    };
  };
}
