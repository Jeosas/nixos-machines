{outputs, ...}: {
  imports = [
    ./hardware.nix
    outputs.nixosModules
    ./monitors.nix
  ];

  # System Emulation
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  jeomod = {
    user = "jeosas";
    groups = [
      "kvm" # android avd
    ];
    stateVersion = "24.05";

    system = {
      impermanence.enable = true;

      network.hostName = "neon";

      audio.enable = true;

      nix.allowUnfree = true;

      graphics = {
        enable = true;
        nvidia.enable = true;
      };

      bluetooth.enable = true;

      ssh.user.config = {
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

    desktop.hyprland.enable = true;

    applications = {
      alacritty.enable = true;

      # Messaging
      signal.enable = true;

      # Browser
      firefox.enable = true;
      mullvad.enable = true;

      # Office
      libreoffice.enable = true;
      pdf.enable = true;
      krita.enable = true;
      inkscape.enable = true;
      freecad.enable = true;

      # Dev
      neovim.enable = true;
      docker.enable = true;
      qemu.enable = true;
      godot.enable = true;

      # Art
      blender.enable = false;

      # Music
      ongaku.enable = true;

      # Gaming
      alvr.enable = true;
      vesktop.enable = true;
      steam.enable = true;
      heroic.enable = true;
      lutris.enable = true;
      ankama-launcher.enable = true;
      oversteer.enable = true;

      # Tools
      wootility.enable = true;
      openrazer.enable = true;
      transmission.enable = true;
    };
  };
}
