{
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.vars) hosts;
in
{
  imports = [ ./hardware.nix ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  ${namespace} = {
    suites = {
      art.enable = true;
      base-workstation.enable = true;
      development = {
        enable = true;
        gamedev.enable = true;
      };
      games = {
        enable = true;
        simracing.enable = true;
        vr.enable = true;
      };
      music.enable = true;
      social.enable = true;
    };

    hardware = {
      graphics.nvidia.enable = true;
      network.hostName = "neon";
      bluetooth.enable = true;
    };

    services = {
      ollama = {
        enable = true;
        acceleration = "cuda";
      };
    };

    virtualisation.docker.enableNvidia = true;

    system.openrazer.enable = true;

    apps = {
      wootility.enable = true;
      monero-gui.enable = true;
      freetube.enable = true;
    };

    desktop.hyprland.config = {
      monitors = [ ",3440x1440@144,auto,1" ];
    };

    home.extraConfig = {
      ${namespace}.tools.ssh.user.config = with hosts; {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "~/.ssh/id_github";
          identitiesOnly = true;
        };
        ${oxygen.network.hostName} = {
          hostname = oxygen.network.ipv4;
          user = "root";
          identityFile = "~/.ssh/id_homelab";
          identitiesOnly = true;
        };
      };
    };
  };

  system.stateVersion = "24.05";
}
