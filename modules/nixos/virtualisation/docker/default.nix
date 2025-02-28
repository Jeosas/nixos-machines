{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt';
  cfg = config.${namespace}.virtualisation.docker;
in
{
  options.${namespace}.virtualisation.docker = with lib.types; {
    enable = mkEnableOption "Docker";
    rootless = mkOpt' bool true;
  };

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      rootless = mkIf cfg.rootless {
        enable = true;
        setSocketVariable = true;
      };
    };

    ${namespace} = {
      user.extraGroups = mkIf cfg.rootless [ "docker" ];
      impermanence = {
        directories = [ "/var/lib/docker" ];
        userDirectories = [ ".config/docker" ];
      };
    };
  };
}
