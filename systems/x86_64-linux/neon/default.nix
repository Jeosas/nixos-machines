{
  lib,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace};
{
  imports = [ ./hardware.nix ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # 565 is broken on kernel 6.13 - https://github.com/NixOS/nixpkgs/issues/375730
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "570.86.16"; # use new 570 drivers
    sha256_64bit = "sha256-RWPqS7ZUJH9JEAWlfHLGdqrNlavhaR1xMyzs8lJhy9U=";
    openSha256 = "sha256-DuVNA63+pJ8IB7Tw2gM4HbwlOh1bcDg2AN2mbEU9VPE=";
    settingsSha256 = "sha256-9rtqh64TyhDF5fFAYiWl3oDHzKJqyOW3abpcf2iNRT8=";
    usePersistenced = false;
  };

  ${namespace} = {
    suites = {
      art = enabled;
      base-workstation = enabled;
      development = {
        enable = true;
        gamedev = enabled;
      };
      games = {
        enable = true;
        simracing = enabled;
        vr = enabled;
      };
      music = enabled;
      social = enabled;
    };

    hardware = {
      graphics.nvidia = enabled;
      network.hostName = "neon";
      bluetooth = enabled;
    };

    services = {
      ollama = {
        enable = true;
        acceleration = "cuda";
      };
    };

    virtualisation.docker.enableNvidia = true;

    system.openrazer = enabled;

    apps = {
      wootility = enabled;
      monero-gui = enabled;
      freetube = enabled;
    };

    desktop.hyprland.config = {
      monitors = [ ",3440x1440@144,auto,1" ];
    };

    home.extraConfig = {
      ${namespace}.tools.ssh.user.config = {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "~/.ssh/id_github";
          identitiesOnly = true;
        };
        "oxygen" = {
          hostname = "192.168.1.8";
          user = "root";
          identityFile = "~/.ssh/id_homelab";
          identitiesOnly = true;
        };
      };
    };
  };

  system.stateVersion = "24.05";
}
