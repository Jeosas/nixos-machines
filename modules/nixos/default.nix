{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.jeomod;
in
  with lib; {
    imports = [
      inputs.home-manager.nixosModules.home-manager

      ./shell
      ./applications
      ./desktop
      ./system
      ./theme.nix

      ./colorscheme-nord.nix
    ];

    options.jeomod = {
      user = mkOption {
        type = types.str;
        description = "Primary user of the system";
      };
      groups = mkOption {
        type = types.listOf types.str;
        description = "Groups for the primary user";
        default = [];
      };
      stateVersion = mkOption {
        type = types.str;
        description = "StateVersion of the system";
      };
    };

    config = {
      system.stateVersion = cfg.stateVersion;

      users.mutableUsers = false;
      users.users.${cfg.user} = {
        isNormalUser = true;
        hashedPasswordFile = mkIf config.jeomod.system.impermanence.enable "${config.jeomod.system.impermanence.systemDir}/${cfg.user}-password";
        description = cfg.user;
        extraGroups = cfg.groups;
        shell = pkgs.zsh;
      };

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;

        users = {
          root.home = {inherit (cfg) stateVersion;};
          ${cfg.user}.home = {
            inherit (cfg) stateVersion;
            username = cfg.user;
            homeDirectory = "/home/${cfg.user}";
          };
        };
      };
    };
  }
