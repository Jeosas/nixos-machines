{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.jeomod.applications.kmonad;

  kmonad = pkgs.kmonad;
in
  with lib; {
    options.jeomod.applications.kmonad = {
      enable = mkEnableOption "kmonad";

      config = mkOption {
        type = types.lines;
        description = "kmonad config";
      };
    };

    config = mkIf cfg.enable {
      hardware.uinput.enable = true;

      jeomod.groups = ["input" "uinput"];

      home-manager.users.${config.jeomod.user} = {
        home.packages = [kmonad];

        xdg.configFile."kmonad/keymap.kbd" = {
          text = cfg.config;
        };

        systemd.user.services."kmonad-keymap" = {
          Unit.Description = "kmonad keyboard config";
          Service = {
            Restart = "always";
            RestartSec = 3;
            ExecStart = "${kmonad}/bin/kmonad %E/kmonad/keymap.kbd";
            Nice = -20;
          };
          Install = {
            WantedBy = ["default.target"];
          };
        };
      };
    };
  }
