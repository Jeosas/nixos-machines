/*
needs som manual interventions
https://github.com/kmonad/kmonad/blob/master/doc/faq.md#q-how-do-i-get-uinput-permissions
https://dev.to/ram535/kmonad-and-the-power-of-infinite-leader-keys-888

```console
# Add self to the input and uinput groups
sudo usermod -aG input $USER
sudo groupadd uinput
sudo usermod -aG uinput $USER

echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' | sudo tee /etc/udev/rules.d/90-uinput.rules

# This seems to be needed because uinput isn't compiled as a loadable module these days.
# See https://github.com/chrippa/ds4drv/issues/93#issuecomment-265300511
echo uinput | sudo tee /etc/modules-load.d/uinput.conf
```
*/
{
  config,
  pkgs,
  ...
}: let
  kmonad = pkgs.kmonad;
  mkKmonadService = configname: {
    Unit.Description = "kmonad keyboard config ${configname}";
    Service = {
      Restart = "always";
      RestartSec = 3;
      ExecStart = "${kmonad}/bin/kmonad %E/kmonad/${configname}.kbd";
      Nice = -20;
    };
    Install = {
      WantedBy = ["default.target"];
    };
  };
in {
  home.packages = [kmonad];

  xdg.configFile."kmonad/tpx1c.kbd" = {
    text =
      /*
      kbd
      */
      ''
        #| -----------------------------------------------------------------------
                               ThinkPad X1 Carbon Gen 8 (ISO)
        ------------------------------------------------------------------------|#

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

        #|-----------------------------------------------------------------------
        (deflayer template
          _       _       _       _       _       _       _       _       _       _       _       _       _       _
          _       _       _       _       _       _       _       _       _       _       _       _       _       _
          _       _       _       _       _       _       _       _       _       _       _       _       _
          _       _       _       _       _       _       _       _       _       _       _       _
          _       _       _                       _                       _               _
        )
        -----------------------------------------------------------------------|#
      '';
  };

  systemd.user.services."kmonad-tpx1c" = mkKmonadService "tpx1c";
}
