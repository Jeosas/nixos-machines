{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.jeomod.system;
in
  with lib; {
    imports = [
      ./graphics
      ./admin.nix
      ./audio.nix
      ./bluetooth.nix
      ./impermanence.nix
      ./network.nix
      ./nix.nix
      ./ssh.nix
    ];

    options.jeomod.system = {
      kernelPackages = mkOption {
        type = types.raw;
        description = "kernel package";
        default = pkgs.linuxPackages_latest;
      };
      hasSSD = mkOption {
        type = types.bool;
        description = "system has ssd";
        default = true;
      };
    };

    config = let
      locale = "en_US.UTF-8";
    in {
      boot = {
        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };

        inherit (cfg) kernelPackages;
      };

      time.timeZone = "Europe/Paris";
      i18n.defaultLocale = locale;
      console = {
        font = "Lat2-Terminus16";
        keyMap = "us";
      };

      services = {
        fstrim.enable = cfg.hasSSD;

        # usb automount
        devmon.enable = true;
        gvfs.enable = true;
        udisks2.enable = true;
      };

      environment.systemPackages = with pkgs; [
        git
        vim
        wget
        tree
      ];

      home-manager.users.${config.jeomod.user}.home = {
        language.base = locale;
      };
    };
  }
