{
  lib,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace};
{
  imports = [
    ./battery.nix
    ./chassis.nix
    ./hardware.nix
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  programs.nix-ld = enabled;

  ${namespace} = {
    suites = {
      art = enabled;
      base-workstation = enabled;
      laptop = enabled;
      development = enabled;
      social = enabled;
    };

    hardware.network.hostName = "fr-jb-xps";
    hardware.bluetooth = enabled;

    desktop = {
      hyprland.config = {
        monitors = [
          "eDP-1,1920x1200@60,auto,1"
          ",preferred,auto,1"
        ];
      };
    };

    apps.zen-browser = enabled;

    services = {
      ollama = enabled;
    };

    theme.wallpaper = ./wallpaper.jpg;

    system.keyd = enabled;
  };

  home-manager.users.${config.${namespace}.user.name}.${namespace} = {
    desktop = {
      addons.waybar = {
        cpu-temp-zone = 6;
      };
    };
    tools = {
      git = {
        userEmail = "jean-baptiste.wintergerst@lumapps.com";
      };
      ssh.user.config = {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "~/.ssh/id_github";
          identitiesOnly = true;
        };
      };
    };
  };

  system.stateVersion = "24.11";
}
