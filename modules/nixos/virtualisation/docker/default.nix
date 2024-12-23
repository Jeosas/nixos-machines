{
  lib,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.virtualisation.docker;
in
with lib;
{
  options.${namespace}.virtualisation.docker = {
    enable = mkEnableOption "Docker";
  };

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };

    ${namespace} = {
      impermanence.directories = [ "/var/lib/docker" ];
    };

    home-manager.users.${config.${namespace}.user.name} = {
      ${namespace}.impermanence.directories = [ ".config/docker" ];
    };
  };
}
