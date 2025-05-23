{
  lib,
  namespace,
  config,
  inputs,
  ...
}:
let
  inherit (lib.${namespace}) mkOpt mkIf;

  username = config.${namespace}.workstation.user.name;

  cfg = config.${namespace}.workstation.impermanence;
in
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options.${namespace}.workstation.impermanence = with lib.types; {
    systemDir = mkOpt str "/persist" "Global persistent directory";
    files = mkOpt (listOf str) [ ] "List of system files to persist";
    directories = mkOpt (listOf str) [ ] "List of system directories to persist";
    userFiles = mkOpt (listOf str) [ ] "List of user files to persist";
    userDirectories = mkOpt (listOf str) [ ] "List of user directories to persist";
  };

  config = mkIf config.workstation.enable {
    # Needed for home-manager impermanence module
    programs.fuse.userAllowOther = true;

    environment.persistence.${cfg.systemDir} = {
      hideMounts = true;
      directories = [
        "/etc/ssh"
        "/var/log"
        "/var/lib/bluetooth" # bluetooth devices
        "/etc/NetworkManager/system-connections" # wifi connections
        "/var/lib/nixos" # nixos groups stuff
        "/tmp" # needed for big nixos builds (thanks electron !)
      ] ++ cfg.directories;
      files = [ "/etc/machine-id" ] ++ cfg.files;

      users.${username} = {
        directories = cfg.userDirectories;
        files = cfg.userFiles;
      };
    };
  };
}
