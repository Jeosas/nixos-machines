{
  lib,
  pkgs,
  namespace,
  inputs,
  config,
  ...
}:
let
  inherit (builtins) length;
  inherit (lib)
    mkIf
    mkEnableOption
    mkMerge
    ;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.user;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.${namespace}.user = with lib.types; {
    name = mkOpt str "jeosas" "The name to use for the user account.";
    home = mkOpt str "/home/${cfg.name}" "The users's home directory.";
    hashedPasswordFile = mkOpt (nullOr str) null "The file path to the hashed user password.";
    extraGroups = mkOpt (listOf str) [ ] "A list of groups for the user to be assigned to.";
    sshKeys = mkOpt (listOf str) [ ] "A list of ssh keys allowed to login to the user.";
    enableHomeManager = mkEnableOption "Enable home-manager support.";
  };

  config = mkMerge [
    {
      assertions = [
        {
          assertion = cfg.hashedPasswordFile == null || (length cfg.sshKeys != 0);
          message = "either hashedPasswordFile or sshKeys must be provided";
        }
      ];

      users = {
        mutableUsers = false;

        users.${cfg.name} = {
          inherit (cfg) name hashedPasswordFile home;

          group = "users";
          shell = pkgs.bash;

          extraGroups = [ "wheel" ] ++ cfg.extraGroups;

          openssh.authorizedKeys = {
            keys = cfg.sshKeys;
          };

          # If false, user is treated as a system user.
          isNormalUser = true;
        };
      };
    }

    (mkIf cfg.enableHomeManager {
      home-manager = {
        extraSpecialArgs = {
          inherit namespace inputs;
          lib = lib.extend (final: prev: inputs.home-manager.lib);
          osConfig = config;
        };

        useUserPackages = true;
        useGlobalPkgs = true;
      };

      home-manager.users.${cfg.name} = {
        home = {
          inherit (config.system) stateVersion;
          homeDirectory = cfg.home;
          username = cfg.name;
        };

        xdg = {
          enable = true;
        };

        systemd.user = {
          enable = true;
          startServices = "sd-switch";
        };
      };

      environment.persistence.main.users.${config.${namespace}.user.name}.directories = [
        ".setup" # nixos config
        "Documents"
        "Pictures"
        "Music"
        "notes"
        "code"
      ];
    })
  ];
}
