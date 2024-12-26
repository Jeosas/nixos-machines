{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.system.kmonad;

  inherit (pkgs) kmonad;
in
with lib;
{
  options.${namespace}.system.kmonad = {
    enable = mkEnableOption "kmonad";

    config = mkOption {
      type = types.lines;
      description = "kmonad config";
    };
  };

  config = mkIf cfg.enable {
    hardware.uinput.enable = true;

    ${namespace}.user.extraGroups = [
      "input"
      "uinput"
    ];

    environment.systemPackages = [ kmonad ];

    systemd.user.services."kmonad-keymap" =
      let
        kmonadConfig = pkgs.writeTextFile {
          name = "kmonad-config";
          text = cfg.config;
        };
      in
      {
        Unit.Description = "kmonad keyboard config";
        Service = {
          Restart = "always";
          RestartSec = 3;
          ExecStart = "${kmonad}/bin/kmonad ${kmonadConfig}";
          Nice = -20;
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
  };
}
