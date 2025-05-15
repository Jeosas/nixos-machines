{
  lib,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.tools.fastfetch;
in
with lib;
with lib.${namespace};
{
  options.${namespace}.tools.fastfetch = {
    enable = mkEnableOption "fastfetch";
  };
  config = mkIf cfg.enable {
    programs = {
      fastfetch = {
        enable = true;
        settings = {
          logo = {
            source = ./shell-init-logo.png;
            height = 22;
          };
          display = {
            separator = "";
            percent = {
              type = 3;
            };
            key.width = 25;
          };
          modules = [
            "title"
            "separator"
            "host"
            {
              type = "cpu";
              temp = true;
            }
            "gpu"
            "break"
            "os"
            "kernel"
            "shell"
            "localip"
            "break"
            "cpuusage"
            "memory"
            "swap"
            "disk"
            "battery"
            "break"
            {
              type = "colors";
              symbol = "circle";
              paddingLeft = 3;
            }
          ];
        };
      };
      zsh = {
        initContent =
          # bash
          ''
            if [ $TERM = xterm-kitty ]; then
              fastfetch
            else
              fastfetch --logo nix
            fi
          '';
      };
    };
  };
}
