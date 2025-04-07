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
    enableNvidia = mkOpt' bool false;
  };

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
    };
    hardware.nvidia-container-toolkit.enable = cfg.enableNvidia;

    ${namespace} = {
      user.extraGroups = [ "docker" ];
      impermanence = {
        directories = [ "/var/lib/docker" ];
        userDirectories = [
          ".config/docker"
          ".docker"
        ];
      };
    };
  };
}
