{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkOpt;

  username = config.${namespace}.user.name;

  cfg = config.${namespace}.impermanence;
in
{
  options.${namespace}.impermanence = with lib.types; {
    enable = mkEnableOption "impermanence";
    systemDir = mkOpt str "/persist" "Global persistent directory";
    files = mkOpt (listOf str) [ ] "List of system files to persist";
    directories = mkOpt (listOf str) [ ] "List of system directories to persist";
    userFiles = mkOpt (listOf str) [ ] "List of user files to persist";
    userDirectories = mkOpt (listOf str) [ ] "List of user directories to persist";
  };

  config = mkIf cfg.enable {
    # Needed for home-manager impermanence module
    programs.fuse.userAllowOther = true;

    environment.persistence.${cfg.systemDir} = {
      inherit (cfg) enable;
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
