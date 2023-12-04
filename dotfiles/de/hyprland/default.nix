{ inputs, config, pkgs, nvidia ? false, ... }:

with pkgs.lib.strings;
{
  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = nvidia;
    systemdIntegration = true;
    xwayland.enable = true;

    extraConfig = ''
      monitor=,preferred,auto,auto

      ${optionalString nvidia ''
      # nvidia setup
      env = LIBVA_DRIVER_NAME,nvidia
      env = XDG_SESSION_TYPE,wayland
      env = GBM_BACKEND,nvidia-drm
      env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      env = WLR_NO_HARDWARE_CURSORS,1
      ''}

      input {
        kb_layout = us
        kb_variant = altgr-intl
        kb_model = pc105

        follow_mouse = 0
      }

      general {
        gaps_in = 5
        gaps_out = 20
        border_size = 2
        col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
        col.inactive_border = rgba(595959aa)
      
        layout = dwindle
      
        allow_tearing = false
      }

      decoration {
        rounding = 10

        blur {
            enabled = true
            size = 3
            passes = 1
        }

        drop_shadow = true
        shadow_range = 4
        shadow_render_power = 3
        col.shadow = rgba(1a1a1aee)
      }

      animations {
        enabled = true

        bezier = myBezier, 0.05, 0.9, 0.1, 1.05

        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 7, default, popin 80%
        animation = border, 1, 10, default
        animation = borderangle, 1, 8, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default
      }    

      dwindle {
        pseudotile = true
        preserve_split = true
      }

      # apps
      bind = SUPER, F, exec, firefox
      bind = SUPER, Return, exec, alacritty

      # workspaces
      # binds SUPER + [shift +] {1..10} to [move to] workspace {1..10}
      ${builtins.concatStringsSep "\n" (builtins.genList (
          x: let
            ws = let
              c = (x + 1) / 10;
            in
              builtins.toString (x + 1 - (c * 10));
          in ''
            bind = SUPER, ${ws}, workspace, ${toString (x + 1)}
            bind = SUPER_SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
          ''
        )
        10)}

      # move around hjkl
      bind = SUPER, h, movefocus, l
      bind = SUPER, l, movefocus, r
      bind = SUPER, k, movefocus, u
      bind = SUPER, j, movefocus, d

      # move around arrows
      bind = SUPER, left, movefocus, l
      bind = SUPER, right, movefocus, r
      bind = SUPER, up, movefocus, u
      bind = SUPER, down, movefocus, d
    '';
  };
}

