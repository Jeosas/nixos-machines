{
  lib,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.apps.envision;
in
with lib;
{
  options.${namespace}.apps.envision = {
    enable = mkEnableOption "envision";
  };

  config = mkIf cfg.enable {
    programs.envision = {
      enable = true;
      openFirewall = true;
    };

    home-manager.users.${config.${namespace}.user.name} = {
      ${namespace}.impermanence.directories = [
        ".config/envision"
      ];
    };
  };
}
