{
  namespace,
  config,
  ...
}:
{
  imports = [
    ./battery.nix
    ./chassis.nix
    ./hardware.nix
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  programs.nix-ld.enable = true;

  ${namespace} = {
    suites = {
      art.enable = true;
      base-workstation.enable = true;
      laptop.enable = true;
      development.enable = true;
      social.enable = true;
    };

    hardware.network.hostName = "fr-jb-xps";
    hardware.bluetooth.enable = true;

    desktop = {
      hyprland.config = {
        monitors = [
          "eDP-1,1920x1200@60,auto,1"
          "desc:Dell Inc. DELL P2415Q,preferred,auto,1.5"
          ",preferred,auto,1"
        ];
      };
    };

    apps.zen-browser.enable = true;
    cli-apps = {
      gh.enable = true;
    };

    services = {
      ollama.enable = true;
      wireguard.enable = true;
    };

    theme.wallpaper = ./wallpaper.jpg;

    tools = {
      azure.enable = true;
      gcloud.enable = true;
      kubectl.enable = true;
    };

    system.keyd.enable = true;
  };

  home-manager.users.${config.${namespace}.user.name}.${namespace} = {
    desktop = {
      addons.waybar = {
        cpu-temp-zone = 6;
      };
    };
    tools = {
      git = {
        userName = "Jean-Baptiste WINTERGERST";
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
