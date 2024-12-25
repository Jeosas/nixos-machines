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
        # simracing = enabled; TODO build failure
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

    system.openrazer = enabled;

    apps.wootility = enabled;

    desktop.hyprland.config = {
      # layout = "hy3";
      monitors = [ ",3440x1440@144,auto,1" ];
    };
  };

  home-manager.users.${config.${namespace}.user.name}.${namespace} = {
    apps.monero-gui = enabled;
    tools.ssh.user.config = {
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

  system.stateVersion = "24.05";
}
