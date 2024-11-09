{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.jeomod.system.impermanence;
in
  with lib; {
    imports = [inputs.impermanence.nixosModules.impermanence];

    options.jeomod.system.impermanence = {
      enable = mkEnableOption "impermanence";
      systemDir = mkOption {
        type = types.str;
        description = "Global persistent directory";
        default = "/persist";
      };
      files = mkOption {
        type = types.listOf types.str;
        description = "List of system files to persist";
        default = [];
      };
      directories = mkOption {
        type = types.listOf types.str;
        description = "List of system directories to persist";
        default = [];
      };
      user = {
        files = mkOption {
          type = types.listOf types.str;
          description = "List of user files to persist";
          default = [];
        };
        directories = mkOption {
          type = types.listOf types.str;
          description = "List of user directories to persist";
          default = [];
        };
      };
    };

    config = mkIf cfg.enable {
      environment.persistence.${cfg.systemDir} = {
        hideMounts = true;
        directories =
          [
            "/etc/ssh"
            "/var/log"
            "/var/lib/bluetooth" # bluetooth devices
            "/etc/NetworkManager/system-connections" # wifi connections
            "/var/lib/nixos" # nixos groups stuff
            "/tmp" # needed for big nixos builds (thanks electron !)
          ]
          ++ cfg.directories;
        files =
          [
            "/etc/machine-id"
          ]
          ++ cfg.files;
        users.${config.jeomod.user} = {
          directories =
            [
              ".setup" # nixos config
              "Documents"
              "Images"
              "Music"
              "notes"
              "code"
              {
                directory = ".ssh";
                mode = "0700";
              } # ssh keys
            ]
            ++ cfg.user.directories;
          files = [] ++ cfg.user.files;
        };
      };
    };
  }
