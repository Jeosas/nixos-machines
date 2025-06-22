{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt';

  cfg = config.${namespace}.apps.docker;
in
{
  options.${namespace}.apps.docker = with lib.types; {
    enable = mkEnableOption "Docker";
    enableNvidia = mkOpt' bool false;
  };

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
    };
    hardware.nvidia-container-toolkit.enable = cfg.enableNvidia;

    ${namespace} = {
      user.extraGroups = [ "docker" ];
    };
    environment.persistence.main = {
      directories = [ "/var/lib/docker" ];
      users.${config.${namespace}.user.name}.directories = [
        ".config/docker"
        ".docker"
      ];
    };
  };
}
