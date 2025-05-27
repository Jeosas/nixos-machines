{
  lib,
  namespace,
  config,
  inputs,
  ...
}:
let
  inherit (lib.${namespace}) mkOpt;

  user = { inherit (config.${namespace}.user) name home; };

  cfg = config.${namespace}.impermanence;
in
{
  imports = [
    ./user.nix
    inputs.impermanence.nixosModules.impermanence
  ];

  options.${namespace}.impermanence = with lib.types; {
    systemDir = mkOpt str "/persist" "Global persistent directory";
    files = mkOpt (listOf str) [ ] "List of system files to persist";
    directories = mkOpt (listOf str) [ ] "List of system directories to persist";
    userFiles = mkOpt (listOf str) [ ] "List of user files to persist";
    userDirectories = mkOpt (listOf str) [ ] "List of user directories to persist";
  };

  config = {
    # Needed for home-manager impermanence module
    programs.fuse.userAllowOther = config.${namespace}.user.enableHomeManager;

    environment.persistence.${cfg.systemDir} = {
      hideMounts = true;

      inherit (cfg) files directories;

      users.${user.name} = {
        inherit (user) home;
        directories = cfg.userDirectories;
        files = cfg.userFiles;
      };
    };
  };
}
