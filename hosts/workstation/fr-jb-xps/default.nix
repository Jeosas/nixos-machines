{
  namespace,
  ...
}:
{
  imports = [
    ./hardware.nix
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Enable lib dynamix linking support
  programs.nix-ld.enable = true;

  ${namespace} = {
    workstation = {
      hostName = "fr-jb-xps";

      hardware = {
        enableSSD = true;
        enableLaptopUtils = true;
        enableBluetooth = true;
      };

      desktop = {
        hyprland.monitors = [
          "eDP-1,1920x1200@60,auto,1"
          "desc:Dell Inc. DELL P2415Q,preferred,auto,1.5"
          ",preferred,auto,1"
        ];
        waybar.cpu-temp-zone = 6;
      };

      # suites = { };

      sshConfig = {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "~/.ssh/id_github";
          identitiesOnly = true;
        };
      };
    };

    theme.wallpaper = ./wallpaper.jpg;

    apps = {
      # keep-sorted start case=no numeric=yes
      azure.enable = true;
      gcloud.enable = true;
      gh.enable = true;
      keyd.enable = true;
      kubectl.enable = true;
      ollama.enable = true;
      wireguard.enable = true;
      # keep-sorted end
    };

    apps.git = {
      userName = "Jean-Baptiste WINTERGERST";
      userEmail = "jean-baptiste.wintergerst@lumapps.com";
    };
  };

  system.stateVersion = "24.11";
}
