{
  lib,
  pkgs,
  namespace,
  config,
  inputs,
  ...
}:

let
  inherit (lib.${namespace}) mkOpt mkOptRequired;

  cfg = config.${namespace}.workstation;
in
{
  imports = [
    # keep-sorted start case=no numeric=yes
    ../impermanence.nix
    ../theme.nix
    ../user.nix
    ./desktop/bongocat.nix
    ./desktop/dunst.nix
    ./desktop/hyprland.nix
    ./desktop/hyprlock.nix
    ./desktop/hyprpaper.nix
    ./desktop/waybar.nix
    ./desktop/wofi.nix
    ./hardware.nix
    ./suites/base.nix
    ./suites/gaming.nix
    ./suites/streaming.nix
    ./suites/simracing.nix
    ./suites/vr.nix
    ./system.nix
    ./theme.nix
    # keep-sorted end
  ]
  ++ import ../module-list.nix;

  options.${namespace}.workstation = with lib.types; {
    hostName = mkOptRequired str "System hostname";
    sshConfig = mkOpt attrs { } "user ssh config";
  };

  config = {
    # system/boot
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      kernelPackages = pkgs.linuxPackages;
    };

    # nix
    nix = {
      settings = {
        experimental-features = "nix-command flakes";
        auto-optimise-store = true;

        substituters = [
          "https://cache.nixos.org/"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
    };

    # nixpkgs
    nixpkgs = {
      config = {
        allowUnfree = true;
      };
      overlays = [
        (import ../../overlay.nix { inherit namespace lib inputs; })
        inputs.nurpkgs.overlays.default
      ];
    };

    # doas
    environment.systemPackages = with pkgs; [ doas-sudo-shim ];
    security = {
      sudo.enable = false;
      doas = {
        enable = true;
        extraRules = [
          {
            groups = [ "wheel" ];
            persist = true;
          }
        ];
      };
      polkit.enable = true;
    };

    # impermanence
    environment.persistence.main = {
      directories = [
        "/etc/ssh"
        "/var/log"
        "/etc/NetworkManager/system-connections" # wifi connections
        "/var/lib" # system service persistent data
        {
          directory = "/var/lib/private";
          user = "root";
          group = "root";
          mode = "700";
        }
      ];
      files = [
        "/etc/machine-id"
      ];
      users.${config.${namespace}.user.name}.directories = [
        ".ssh"
        ".config/sops/age"
      ];
    };

    ${namespace} = {
      impermanence.enable = true;
      # user
      user = {
        hashedPasswordFile =
          let
            impermanenceDir = config.${namespace}.impermanence.systemDir;
            username = config.${namespace}.user.name;
          in
          "${impermanenceDir}/${username}-password";
        enableHomeManager = true;
      };
    };

    home-manager.users.${config.${namespace}.user.name} = {
      # ssh
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks = {
          "*" = {
            addKeysToAgent = "yes";
            forwardAgent = false;
            compression = false;
            serverAliveInterval = 0;
            serverAliveCountMax = 3;
            hashKnownHosts = false;
            userKnownHostsFile = "~/.ssh/known_hosts";
            controlMaster = "no";
            controlPath = "~/.ssh/master-%r@%n:%p";
            controlPersist = "no";
          };
        }
        // cfg.sshConfig;
      };
    };
  };
}
