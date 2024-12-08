{
  lib,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.desktop.addons.dunst;
in {
  options.${namespace}.desktop.addons.dunst = {enable = mkEnableOption "dunst";};

  config = mkIf cfg.enable {
    ${namespace}.desktop.hyprland.config.exec-once = [
      "dunst &"
    ];

    home-manager.users.${config.${namespace}.user.name} = {
      services.dunst = {
        enable = true;
      };

      xdg.configFile."dunst/dunstrc" = {
        text = let
          inherit (config.${namespace}.theme) colors fonts;
        in ''
          [global]
              ### Display ###

              # Which monitor should the notifications be displayed on.
              monitor = 0

              # Display notification on focused monitor.  Possible modes are:
              #   mouse: follow mouse pointer
              #   keyboard: follow window with keyboard focus
              #   none: don't follow anything
              #
              # "keyboard" needs a window manager that exports the
              # _NET_ACTIVE_WINDOW property.
              # This should be the case for almost all modern window managers.
              #
              # If this option is set to mouse or keyboard, the monitor option
              # will be ignored.
              follow = keyboard

              ### Geometry ###

              # dynamic width from 0 to 300
              # width = (0, 300)
              # constant width of 300
              width = 400

              # The maximum height of a single notification, excluding the frame.
              height = 200

              # Position the notification in the top right corner
              origin = bottom-right

              # Offset from the origin
              offset = 16x16

              # Scale factor. It is auto-detected if value is 0.
              scale = 0

              # Maximum number of notification (0 means no limit)
              notification_limit = 0

              ### Progress bar ###

              # Turn on the progess bar. It appears when a progress hint is passed with
              # for example dunstify -h int:value:12
              progress_bar = true

              # Set the progress bar height. This includes the frame, so make sure
              # it's at least twice as big as the frame width.
              progress_bar_height = 8

              # Set the frame width of the progress bar
              progress_bar_frame_width = 0

              # Set the minimum width for the progress bar
              progress_bar_min_width = 350

              # Set the maximum width for the progress bar
              progress_bar_max_width = 400


              # Show how many messages are currently hidden (because of
              # notification_limit).
              indicate_hidden = yes

              # The transparency of the window.  Range: [0; 100].
              # This option will only work if a compositing window manager is
              # present (e.g. xcompmgr, compiz, etc.). (X11 only)
              transparency = 0

              # Draw a line of "separator_height" pixel height between two
              # notifications.
              # Set to 0 to disable.
              # If gapsize is greater than 0, this setting will be ignored.
              separator_height = 2

              # Padding between text and separator.
              padding = 12

              # Horizontal padding.
              horizontal_padding = 15

              # Padding between text and icon.
              text_icon_padding = 0

              # Defines width in pixels of frame around the notification window.
              # Set to 0 to disable.
              frame_width = 2

              # Defines color of the frame around the notification window.
              frame_color = "${colors.color2}"

              # Size of gap to display between notifications - requires a compositor.
              # If value is greater than 0, separator_height will be ignored and a border
              # of size frame_width will be drawn around each notification instead.
              # Click events on gaps do not currently propagate to applications below.
              # WARNING: doesn't exist?
              # gap\_size = 5

              # Define a color for the separator.
              # possible values are:
              #  * auto: dunst tries to find a color fitting to the background;
              #  * foreground: use the same color as the foreground;
              #  * frame: use the same color as the frame;
              #  * anything else will be interpreted as a X color.
              separator_color = auto

              # Sort messages by urgency.
              sort = yes

              # Don't remove messages, if the user is idle (no mouse or keyboard input)
              # for longer than idle_threshold seconds.
              # Set to 0 to disable.
              # A client can set the 'transient' hint to bypass this. See the rules
              # section for how to disable this if necessary
              # idle_threshold = 120

              ### Text ###

              font = ${fonts.sans} 11

              # The spacing between lines.  If the height is smaller than the
              # font height, it will get raised to the font height.
              line_height = 0

              # Possible values are:
              # full: Allow a small subset of html markup in notifications:
              #        <b>bold</b>
              #        <i>italic</i>
              #        <s>strikethrough</s>
              #        <u>underline</u>
              #
              #        For a complete reference see
              #        <https://docs.gtk.org/Pango/pango_markup.html>.
              #
              # strip: This setting is provided for compatibility with some broken
              #        clients that send markup even though it's not enabled on the
              #        server. Dunst will try to strip the markup but the parsing is
              #        simplistic so using this option outside of matching rules for
              #        specific applications *IS GREATLY DISCOURAGED*.
              #
              # no:    Disable markup parsing, incoming notifications will be treated as
              #        plain text. Dunst will not advertise that it has the body-markup
              #        capability if this is set as a global setting.
              #
              # It's important to note that markup inside the format option will be parsed
              # regardless of what this is set to.
              markup = full

              # The format of the message.  Possible variables are:
              #   %a  appname
              #   %s  summary
              #   %b  body
              #   %i  iconname (including its path)
              #   %I  iconname (without its path)
              #   %p  progress value if set ([  0%] to [100%]) or nothing
              #   %n  progress value if set without any extra characters
              #   %%  Literal %
              # Markup is allowed
              format = "<small>%a</small>\n<b>%s %p</b>\n%b"

              # Alignment of message text.
              # Possible values are "left", "center" and "right".
              alignment = left

              # Vertical alignment of message text and icon.
              # Possible values are "top", "center" and "bottom".
              vertical_alignment = center

              # Show age of message if message is older than show_age_threshold
              # seconds.
              # Set to -1 to disable.
              show_age_threshold = 60

              # Specify where to make an ellipsis in long lines.
              # Possible values are "start", "middle" and "end".
              ellipsize = "end"

              # Ignore newlines '\n' in notifications.
              ignore_newline = no

              # Stack together notifications with the same content
              stack_duplicates = true

              # Hide the count of stacked notifications with the same content
              hide_duplicate_count = false

              # Display indicators for URLs (U) and actions (A).
              show_indicators = yes

              ### Icons ###

              # Align icons left/right/top/off
              icon_position = left
              # Scale small icons up to this size, set to 0 to disable. Helpful
              # for e.g. small files or high-dpi screens. In case of conflict,
              # max_icon_size takes precedence over this.
              min_icon_size = 32

              # Scale larger icons down to this size, set to 0 to disable
              max_icon_size = 64

              # Paths to default icons.
              icon_path = /usr/share/icons/gnome/128x128/status/:/usr/share/icons/gnome/128x128/devices/
              icon_theme = "Papirus, Adwaita"
              enable_recursive_icon_lookup = true

              # always_run_scripts = true
              ### History ###

              # Should a notification popped up from history be sticky or timeout
              # as if it would normally do.
              sticky_history = yes

              # Maximum amount of notifications kept in history
              history_length = 20

              ### Misc/Advanced ###

              # dmenu path.
              dmenu = wofi --show dmenu -p dunst:

              # Browser for opening urls in context menu.
              browser = /usr/bin/xdg-open

              # Always run rule-defined scripts, even if the notification is suppressed
              always_run_script = true

              # Define the title of the windows spawned by dunst
              title = Dunst

              # Define the class of the windows spawned by dunst
              class = Dunst

              # Define the corner  of the notification window
              # in pixel size. If the radius is 0, you have no rounded
              # corners.
              # The radius will be automatically lowered if it exceeds half of the
              # notification height to avoid clipping text and/or icons.
              corner_radius = 6

              # Ignore the dbus closeNotification message.
              # Useful to enforce the timeout set by dunst configuration. Without this
              # parameter, an application may close the notification sent before the
              # user defined timeout.
              ignore_dbusclose = false

              ### Wayland ###
              # These settings are Wayland-specific. They have no effect when using X11

              # Uncomment this if you want to let notications appear under fullscreen
              # applications (default: overlay)
              layer = top

              # Set this to true to use X11 output on Wayland.
              force_xwayland = false

              ### Legacy

              # Use the Xinerama extension instead of RandR for multi-monitor support.
              # This setting is provided for compatibility with older nVidia drivers that
              # do not support RandR and using it on systems that support RandR is highly
              # discouraged.
              #
              # By enabling this setting dunst will not be able to detect when a monitor
              # is connected or disconnected which might break follow mode if the screen
              # layout changes.
              force_xinerama = false

              ### mouse

              # Defines list of actions for each mouse event
              # Possible values are:
              # * none: Don't do anything.
              # * do_action: Invoke the action determined by the action_name rule. If there is no
              #              such action, open the context menu.
              # * open_url: If the notification has exactly one url, open it. If there are multiple
              #             ones, open the context menu.
              # * close_current: Close current notification.
              # * close_all: Close all notifications.
              # * context: Open context menu for the notification.
              # * context_all: Open context menu for all notifications.
              # These values can be strung together for each mouse event, and
              # will be executed in sequence.
              mouse_left_click = close_current
              mouse_middle_click = close_all
              mouse_right_click = do_action

          # Experimental features that may or may not work correctly. Do not expect them
          # to have a consistent behaviour across releases.
          [experimental]
              # Calculate the dpi to use on a per-monitor basis.
              # If this setting is enabled the Xft.dpi value will be ignored and instead
              # dunst will attempt to calculate an appropriate dpi value for each monitor
              # using the resolution and physical size. This might be useful in setups
              # where there are multiple screens with very different dpi values.
              per_monitor_dpi = false

          [urgency_low]
              # IMPORTANT: colors have to be defined in quotation marks.
              # Otherwise the "#" and following would be interpreted as a comment.
              background = "${colors.background}"
              foreground = "#ffffff"
              timeout = 3
              highlight = "#ffffff"
              # script = ~/.scripts/dunst/sound-normal.sh
              # Icon for notifications with low urgency, uncomment to enable
              #default_icon = /path/to/icon

          [urgency_normal]
              background = "${colors.background}"
              foreground = "#ffffff"
              timeout = 6
              highlight = "#ffffff"
              # script = ~/.scripts/dunst/sound-normal.sh
              # Icon for notifications with normal urgency, uncomment to enable
              # default_icon = /path/to/icon

          [urgency_critical]
              background = "${colors.background}"
              foreground = "#ffffff"
              frame_color = "${colors.color1}"
              timeout = 0
              highlight = "#ffffff"
              # script = ~/.scripts/dunst/sound-critical.sh
              # Icon for notifications with critical urgency, uncomment to enable
              #default_icon = /path/to/icon

          # Every section that isn't one of the above is interpreted as a rules to
          # override settings for certain messages.
          #
          # Messages can be matched by
          #    appname (discouraged, see desktop_entry)
          #    body
          #    category
          #    desktop_entry
          #    icon
          #    match_transient
          #    msg_urgency
          #    stack_tag
          #    summary
          #
          # and you can override the
          #    background
          #    foreground
          #    format
          #    frame_color
          #    fullscreen
          #    new_icon
          #    set_stack_tag
          #    set_transient
          #    set_category
          #    timeout
          #    urgency
          #    icon_position
          #    skip_display
          #    history_ignore
          #    action_name
          #    word_wrap
          #    ellipsize
          #    alignment
          #    hide_text
          #
          # Shell-like globbing will get expanded.
          #
          # Instead of the appname filter, it's recommended to use the desktop_entry filter.
          # GLib based applications export their desktop-entry name. In comparison to the appname,
          # the desktop-entry won't get localized.
          #
          # SCRIPTING
          # You can specify a script that gets run when the rule matches by
          # setting the "script" option.
          # The script will be called as follows:
          #   script appname summary body icon urgency
          # where urgency can be "LOW", "NORMAL" or "CRITICAL".
          #
          # NOTE: It might be helpful to run dunst -print in a terminal in order
          # to find fitting options for rules.

          [volume]
              stack_tag = myvolume
              origin = top-center
              offset = 0x30
              font = ${fonts.sans} 14
              format = "<b>%s</b>"
              history_ignore=yes

          [brightness]
              stack_tag = mybrightness
              origin = top-center
              offset = 0x30
              font = ${fonts.sans} 14
              format = "<b>%s</b>"
              history_ignore=yes
        '';
      };
    };
  };
}
