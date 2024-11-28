{namespace, ...}: {
  imports = [
    ./hardware.nix
    ./battery.nix
    ./monitors.nix
  ];

  # System Emulation
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  # Firmeare update software
  services.fwupd.enable = true;

  # Trackpoint
  hardware = {
    trackpoint = {
      enable = true;
      emulateWheel = true;
    };
  };

  ${namespace} = {
    user = "jeosas";
    # groups = [];

    stateVersion = "24.05";

    system = {
      isLaptop = true;

      impermanence.enable = true;

      network.hostName = "helium";

      audio.enable = true;

      nix.allowUnfree = true;

      graphics = {
        enable = true;
      };

      bluetooth.enable = true;

      ssh.user.config = {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "~/.ssh/id_github";
          identitiesOnly = true;
        };
        "oxygen" = {
          hostname = "192.168.1.8";
          user = "root";
          identityFile = "~/.ssh/id_homelab";
          identitiesOnly = true;
        };
      };
    };

    desktop.hyprland.enable = true;

    applications = {
      alacritty.enable = true;

      # Messaging
      signal.enable = true;

      # Browser
      firefox.enable = true;
      mullvad.enable = true;
      ungoogled-chromium.enable = true;

      # Office
      libreoffice.enable = true;
      pdf.enable = true;
      krita.enable = true;
      inkscape.enable = true;
      freecad.enable = true;

      # Dev
      neovim.enable = true;
      docker.enable = true;

      # Art
      blender.enable = false;

      # Gaming
      vesktop.enable = true;
      ankama-launcher.enable = true;

      # Music
      mixxx.enable = true;
      ongaku.enable = true;

      # Tools
      transmission.enable = true;
      kmonad = {
        enable = true;
        config =
          /*
          kbd
          */
          ''
            (defcfg
              input  (device-file "/dev/input/by-path/platform-i8042-serio-0-event-kbd")
              output (uinput-sink "kmonad-laptop" "/run/current-system/sw/bin/sleep 1 && /run/current-system/sw/bin/setxkbmap -option compose:ralt")
              cmp-seq ralt
              cmp-seq-delay 5
              fallthrough true
              allow-cmd false
            )

            (defalias
              caps (tap-hold 500 esc (layer-toggle layer1))
            )

            (defsrc
              `       1       2       3       4       5       6       7       8       9       0       -       =       bspc
              tab     q       w       e       r       t       y       u       i       o       p       [       ]       ret
              caps    a       s       d       f       g       h       j       k       l       ;       '       lsgt
              lsft    z       x       c       v       b       n       m       ,       .       /       rsft
              lctl    lmet    lalt                    spc                     ralt            rctrl
            )

            (deflayer default
              `       1       2       3       4       5       6       7       8       9       0       -       =       bspc
              tab     q       w       e       r       t       y       u       i       o       p       [       ]       ret
              @caps   a       s       d       f       g       h       j       k       l       ;       '       lsgt
              lsft    z       x       c       v       b       n       m       ,       .       /       rsft
              lctl    lmet    lalt                    spc                     ralt            rctrl
            )

            (deflayer layer1
              _       _       _       _       _       _       _       _       _       _       _       _       _       _
              _       _       _       _       _       _       _       _       _       _       _       _       _       _
              _       _       _       _       _       _       left    down    up      right   _       _       _
              _       _       _       _       _       _       _       _       _       _       _       _
              _       _       _                       _                       _               _
            )

          '';
      };
    };
  };
}
