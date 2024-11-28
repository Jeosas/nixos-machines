{
  lib,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.suites.base-workstation;
in
  with lib;
  with lib.${namespace}; {
    options.${namespace}.suites.base-workstation = {enable = mkEnableOption "base workstation suite";};

    config = mkIf cfg.enable {
      ${namespace} = {
        apps.alacritty = enabled;

        desktop.hyprland = {
          enable = true;
          enableZshLaunchOnLogin = true;
        };

        hardware = {
          audio = enabled;
          graphics = enabled;
          network = enabled;
          ssd = enabled;
        };

        impermanence = enabled;

        security.doas = enabled;

        system = {
          auto-mount = enabled;
          boot = enabled;
          fonts = enabled;
          locale = enabled;
          time = enabled;
        };

        theme = {
          cursor = enabled;
          gtk = enabled;
        };
      };

      home-manager.users.${config.${namespace}.user.name} = {
        ${namespace} = {
          apps = {
            firefox = enabled;
            libreoffice = enabled;
            mullvad = enabled;
            transmission = enabled;
            ungoogled-chromium = enabled;
            xournal = enabled;
          };
          cli-apps = {
            btop = enabled;
            home-manager = enabled;
            neovim = enabled;
            yazi = enabled;
          };
          tools = {
            bat = enabled;
            choudai = enabled;
            git = enabled;
            ripgrep = enabled;
            ssh = enabled;
            starship = enabled;
            zsh = enabled;
          };
        };
      };
    };
  }
