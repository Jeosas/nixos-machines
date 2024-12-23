{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.apps.wootility;
in
with lib;
{
  options.${namespace}.apps.wootility = {
    enable = mkEnableOption "Wootility";
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.wooting-udev-rules ];

    ${namespace} = {
      user.extraGroups = [ "input" ];
    };

    home-manager.users.${config.${namespace}.user.name} = {
      home.packages = [ pkgs.wootility ];
    };
  };
}
