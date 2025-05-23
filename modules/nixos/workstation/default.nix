{
  lib,
  pkgs,
  namespace,
  config,
  inputs,
  ...
}:

let
  inherit (lib) mkEnableOption;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.workstation;
in
{
  imports = [
    ./hardware.nix
    ./impermanence.nix
    ./system.nix
  ];

  options.${namespace}.workstation = with lib.types; {
    enable = mkEnableOption "Enable base system fro workstations";
    hostName = mkOpt str "" "System hostname";
    user = {
      name = mkOpt str "" "Name of the system user";
      extraGroups = mkOpt (listOf str) [ ] "The Unix groups that workstation user should be assigned to";
    };
  };

  config = {
    assertions = [
      {
        assertion = cfg.user.name != "";
        message = "user.name must be provided";
      }
      {
        assertion = cfg.hostName != "";
        message = "hostName must be provided";
      }
    ];

    # system/boot
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      kernelPackages = pkgs.linuxPackages_latest;
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

    # security/doas
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

    # user
    users.users.${cfg.user.name} = {
      mutableUsers = false;
      isNormalUser = true;
      hashedPasswordFile = "${cfg.impermanence.systemDir}/${cfg.name}-password";

      home = "/home/${cfg.user.name}";
      group = "users";

      extraGroups = cfg.user.extraGroups ++ [ "wheel" ];
      shell = pkgs.zsh;
    };
    programs.zsh.enable = true;
  };
}
