{
  lib,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace}; {
  imports = [
    ./battery.nix
    ./hardware.nix
  ];

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  ${namespace} = {
    suites = {
      art = enabled;
      base-workstation = enabled;
      laptop = enabled;
      development = enabled;
      music = {
        enable = true;
        dj = enabled;
      };
      social = enabled;
    };

    hardware.network.hostName = "helium";
    hardware.bluetooth = enabled;

    desktop = {
      hyprland.config = {
        monitors = [
          "eDP-1,1920x1080@60,auto,1"
          "HDMI-A-1,1920x1080@60,auto,1"
          ",preferred,auto,1"
        ];
      };
      addons.waybar = {
        cpu-temp-zone = 6;
      };
    };

    system.kmonad = {
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

  home-manager.users.${config.${namespace}.user.name}.${namespace} = {
    tools.ssh.user.config = {
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

  # Firmeare update software
  services.fwupd.enable = true;

  # Trackpoint
  hardware = {
    trackpoint = {
      enable = true;
      emulateWheel = true;
    };
  };

  system.stateVersion = "24.05";
}
