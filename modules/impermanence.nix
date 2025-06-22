{
  lib,
  namespace,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption;
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
    enable = mkEnableOption "impermanence";
    systemDir = mkOpt str "/persist" "Global persistent directory";
  };

  config = {
    # Needed for home-manager impermanence module
    programs.fuse.userAllowOther = config.${namespace}.user.enableHomeManager;

    environment.persistence.main = {
      inherit (cfg) enable;
      persistentStoragePath = cfg.systemDir;
      hideMounts = true;

      users.${user.name} = {
        inherit (user) home;
      };
    };
  };
}
