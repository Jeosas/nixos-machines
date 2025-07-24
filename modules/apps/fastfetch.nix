{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.fastfetch;
in
{
  options.${namespace}.apps.fastfetch = {
    enable = mkEnableOption "fastfetch";
  };
  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.${namespace}.user.enableHomeManager;
        message = "Home-manager is not enabled.";
      }
    ];

    home-manager.users.${config.${namespace}.user.name} = {
      programs = {
        fastfetch = {
          enable = true;
          settings = {
            logo = {
              source = ./shell-init-logo.png;
              height = 18;
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
        bash = {
          initExtra =
            # bash
            ''
              if [ "$TERM" = xterm-ghostty ]; then
                fastfetch
              fi
            '';
        };
      };
    };
  };
}
