{ enableBattery ? false
, enableBluetooth ? false
, hasGPU ? false
}:

{ config, pkgs, lib, ... }:

let
  inherit (pkgs) writeShellScript;
  inherit (lib) mkIf mkMerge;

  terminal = config.xsession.windowManager.i3.config.terminal;

  get_music = writeShellScript "get_music" /* bash */ ''
    #! ${pkgs.bash}/bin/bash
    PLAYER="%any"
    FORMAT="{{ title }} - {{ artist }}"
    # player status
    PLAYERCTL_STATUS=$(playerctl --player=$PLAYER status 2>/dev/null)
    EXIT_CODE=$?
    if [ $EXIT_CODE -eq 0 ]; then
        STATUS=$PLAYERCTL_STATUS
    else
        STATUS="No player is running"
    fi
    if [ "$1" == "--status" ]; then
        # return status
        echo "$STATUS"
    else
        # return player info
        if [ "$STATUS" = "Stopped" ]; then
            echo "No music is playing"
        elif [ "$STATUS" = "Paused"  ]; then
            playerctl --player=$PLAYER metadata --format "$FORMAT"
        elif [ "$STATUS" = "No player is running"  ]; then
            echo "$STATUS"
        else
            playerctl --player=$PLAYER metadata --format "$FORMAT"
        fi
    fi
  '';

  scroll_music_status = writeShellScript "scroll_music_status" /* bash */ ''
    #! ${pkgs.bash}/bin/bash
    zscroll -l 40 \
            --delay 0.3 \
            --scroll-padding "      " \
            --match-command "${get_music} --status" \
            --match-text "Playing" "--scroll 1" \
            --match-text "Paused" "--scroll 0" \
            --update-check true ${get_music} &
    wait
  '';

  bluetooth_toggle = writeShellScript "bluetooth_toggle" /* bash */ ''
    #! ${pkgs.bash}/bin/bash
    #!${pkgs.bash}
    if [ $(${pkgs.bluez}/bin/bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]
    then
      ${pkgs.bluez}/bin/bluetoothctl power on
    else
      ${pkgs.bluez}/bin/bluetoothctl power off
    fi
  '';

  bluetooth_status = writeShellScript "bluetooth_status" /* bash */ ''
    #! ${pkgs.bash}/bin/bash
    if [ $(${pkgs.bluez}/bin/bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]
    then
      echo "%{F#5c6370}"
    else
      if [ $(echo info | ${pkgs.bluez}/bin/bluetoothctl | grep 'Device' | wc -c) -eq 0 ]
      then
        echo ""
      else
        echo "%{F#61afef}"
      fi
    fi
  '';

  load = writeShellScript "load" /* bash */ ''
    #! ${pkgs.bash}/bin/bash
    load=$(echo "r = $(awk '{ print $3 }' /proc/loadavg)/$(nproc)*100; scale=1; r/1" | bc -l)
    if [[ 1 -eq "$(echo "$load > 100" | bc)" ]]; then
    	echo %{F#BC412B}%{u#BC412B}" $load%"%{F- u-}
    elif [[ 1 -eq "$(echo "$load > 90" | bc)" ]]; then
    	echo %{F#DC602E}%{u#DC602E}" $load%"%{F- u-}
    else
    	echo " $load%"
    fi
  '';

  load_gpu = writeShellScript "load_gpu" /* bash */ ''
    #! ${pkgs.bash}/bin/bash
    load=$(echo "r = $(awk '{ print $3 }' /proc/loadavg)/$(nproc)*100; scale=1; r/1" | bc -l)
    if [[ 1 -eq "$(echo "$load > 100" | bc)" ]]; then
    	pload=$(echo %{F#BC412B}%{u#BC412B} CPU "$load%"%{F- u-})
    elif [[ 1 -eq "$(echo "$load > 90" | bc)" ]]; then
    	pload=$(echo %{F#DC602E}%{u#DC602E} CPU "$load%"%{F- u-})
    else
    	pload=$(echo  CPU "$load%")
    fi

    load=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader | awk '{ print $1 }')
    if [[ 1 -eq "$(echo "$load > 90" | bc)" ]]; then
    	echo %{F#BC412B}%{u#BC412B}"$pload  GPU $load%"%{F- u-}
    elif [[ 1 -eq "$(echo "$load > 70" | bc)" ]]; then
    	echo %{F#DC602E}%{u#DC602E}"$pload  GPU $load%"%{F- u-}
    else
    	echo "$pload  GPU $load%"
    fi
  '';

  temp_gpu = writeShellScript "temp_gpu" /* bash */ ''
    #! ${pkgs.bash}/bin/bash
    temp=$(sensors coretemp-isa-0000 | grep "Package id 0" | sed 's/(.*)//;s/°C.*//;s/.*+//')
    if [ 1 -eq "$(echo "$temp > 85" | bc)" ]; then
    	ptemp=$(echo %{F#BC412B}%{u#BC412B} CPU "$temp"°C%{F- u-})
    elif [ 1 -eq "$(echo "$temp > 75" | bc)" ]; then
    	ptemp=$(echo %{F#DC602E}%{u#DC602E} CPU "$temp"°C%{F- u-})
    else
    	ptemp=$(echo  CPU "$temp"°C)
    fi

    temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader)
    if [ 1 -eq "$(echo "$temp > 85" | bc)" ]; then
    	echo %{F#BC412B}%{u#BC412B}"$ptemp"  GPU "$temp"°C%{F- u-}
    elif [ 1 -eq "$(echo "$temp > 75" | bc)" ]; then
    	echo %{F#DC602E}%{u#DC602E}"$ptemp"  GPU "$temp"°C%{F- u-}
    else
    	echo "$ptemp"  GPU "$temp"°C
    fi
  '';

  temp = writeShellScript "temp" /* bash */ ''
    #! ${pkgs.bash}/bin/bash
    temp=$(sensors coretemp-isa-0000 | grep "Package id 0" | sed 's/(.*)//;s/°C.*//;s/.*+//')
    if [ 1 -eq "$(echo "$temp > 85" | bc)" ]; then
    	echo %{F#BC412B}%{u#BC412B} CPU "$temp"°C%{F- u-}
    elif [ 1 -eq "$(echo "$temp > 75" | bc)" ]; then
    	echo %{F#DC602E}%{u#DC602E} CPU "$temp"°C%{F- u-}
    else
    	echo  CPU "$temp"°C
    fi
  '';
in
{
  home.packages = with pkgs; [
    coreutils
    gnugrep
    gnused
    gawk
    bc
    lm_sensors
    playerctl
    zscroll
    ncpamixer
    bluetuith
  ];

  services.polybar = rec {
    enable = true;
    package = pkgs.polybar.override {
      i3Support = true;
      pulseSupport = true;
    };
    script = "${package}/bin/polybar main &";
    settings =
      let
        padding = {
          inner = 2;
          outer = 2;
        };
        colors = {
          background = config.colors.background;
          primary = config.colors.color10;
          warning = config.colors.color1;
          danger = config.colors.color9;
        };
        bar-common = {
          wm-restack = "i3";
          enable-ipc = true;
          width = "100%";
          height = 22;
          background = colors.background;
          foreground = colors.primary;
          line-size = 2;
          line-color = colors.primary;
          border-size = 0;
          modules-margin = 0;
          font = [
            "Hack Nerd Font:style=Regular:size=9;3"
            "mplus Nerd Font Mono:style=Regular:size=9;3"
          ];
          tray-position = "right";
        };
      in
      {
        "global/wm" = {
          margin-bottom = 0;
          margin-top = 0;
        };
        # Bars
        "bar/main" = mkMerge [
          bar-common
          {
            modules-left = "power i3 load memory temp";
            modules-center = "music";
            modules-right = "drives updates bluetooth network_wlan network_eth volume battery date";
          }
        ];
        "bar/secondary" = mkMerge [
          bar-common
          {
            modules-left = "power i3";
            modules-right = "date";
          }
        ];
        # Modules
        "module/power" = {
          type = "custom/text";
          format = {
            text = "";
            padding = 2;
          };
          click-left = "~/.config/rofi/menus/power";
        };
        "module/i3" = {
          type = "internal/i3";
          pin-workspaces = true;
          strip-wsnumbers = true;
          index-sort = false;
          wrapping-scroll = false;
          reverse-scroll = false;
          label = {
            focused = {
              text = "%name%";
              overline = colors.primary;
              padding = 1;
            };
            unfocused = {
              text = "%name%";
              padding = 1;
            };
            visible = {
              text = "%name%";
              overline = colors.primary;
              padding = 1;
            };
            urgent = {
              text = "%name%";
              foreground = colors.warning;
              overline = colors.warning;
              padding = 1;
            };
            padding = {
              left = padding.inner;
              right = padding.outer;
            };
            mode.foreground = colors.danger;
          };
        };
        "module/music" =
          {
            type = "custom/script";
            tail = true;
            format = {
              prefix = " ";
              text = "<label>";
            };
            exec = "${scroll_music_status}";
            click-left = "playerctl --player=%any play-pause";
          };
        "module/date" = {
          type = "internal/date";
          date = "%e %b %Y";
          time = "%H:%M";
          label = {
            text = "%date%  %time%";
            padding = {
              left = padding.inner;
              right = padding.outer;
            };
          };
        };
        "module/battery" = mkIf enableBattery {
          type = "internal/battery";
          low-at = "10";
          ramp-capacity = [ "" "" "" "" "" "" "" "" "" "" ];
          ramp-charging = [ "" "" "" "" "" "" ];

          format = {
            charging = {
              text = "<ramp-charging> <label-charging>";
              padding = padding.inner;
            };
            discharging = {
              text = "<ramp-capacity> <label-discharging>";
              padding = padding.inner;
            };
            full = {
              text = "ﮣ <label-full>";
              padding = padding.inner;
            };
            low = {
              text = "<ramp-capacity> <label-low>";
              overline = colors.danger;
              padding = padding.inner;
            };
          };
          label = {
            charging = "%percentage%%";
            discharging = "%percentage%%";
            full = "%percentage%%";
            low = "%percentage%%";
          };
        };
        "module/volume" = {
          type = "internal/pulseaudio";
          sink = "";
          use-ui-max = false;
          interval = 5;
          ramp-volume = [ "奄" "奔" "墳" ];
          format = {
            volume = {
              text = "<ramp-volume> <label-volume>";
              padding = padding.inner;
            };
            muted = {
              text = "<label-muted>";
              padding = padding.inner;
              overline = colors.warning;
            };
          };
          label-muted = "ﱝ muted";
          click-right = "${terminal} -e ncpamixer";
        };
        "module/network_eth" = {
          type = "internal/network";
          interface = "enp3s0";
          interval = 3;
          format = {
            connected = {
              text = "<label-connected>";
              background = colors.background;
              padding = padding.inner;
            };
          };
          label-connected = " %upspeed%  %downspeed% ";
        };
        "module/network_wlan" = {
          type = "internal/network";
          interface = "wlan0";
          interval = 3;
          format = {
            connected = {
              text = "<label-connected>";
              background = colors.background;
              padding = padding.inner;
            };
          };
          label-connected = " %upspeed%  %downspeed% ";
        };
        "module/bluetooth" = mkIf enableBluetooth {
          type = "custom/script";
          exec = bluetooth_status;
          interval = 2;
          click = {
            left = "exec ${terminal} -e bluetuith";
            right = "exec ${bluetooth_toggle}";
          };
          format = {
            text = "<label>";
            padding = padding.inner;
          };
          label = "%output%";
        };
        "module/updates" = {
          type = "custom/script";

          exec = "checkupdates | wc -l";
          interval = 1800;

          format = {
            text = " <label>";
            padding = padding.inner;
          };
          label = "%output%";
        };
        "module/drives" = {
          type = "internal/fs";
          mount = [ "/" ];
          interval = 60;
          fixed-values = true;
          spacing = 0;
          format = {
            mounted = {
              text = " <label-mounted>";
              background = colors.background;
              padding = padding.inner;
            };
            unmounted = {
              text = " not mounted";
              background = colors.background;
              padding = padding.inner;
            };
          };
          label-mounted = "%percentage_used%%";
        };
        "module/memory" = {
          type = "internal/memory";
          interval = 6;
          format = {
            text = " <label>";
            background = colors.background;
            padding = padding.inner;
            label = "%percentage_used%%";
          };
        };
        "module/load" = {
          type = "custom/script";
          exec = if hasGPU then "${load_gpu}" else "${load}";
          interval = 6;
          format = {
            text = "<label>";
            padding = padding.inner;
          };
          label = "%output%";
        };
        "module/temp" = {
          type = "custom/script";
          exec = if hasGPU then "${temp_gpu}" else "${temp}";
          interval = 6;
          format = {
            text = "<label>";
            padding = padding.inner;
          };
          label = "%output%";
        };
      };
  };
}




