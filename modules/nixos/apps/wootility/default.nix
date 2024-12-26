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
    environment.systemPackages = [ pkgs.wootility ];

    ${namespace} = {
      user.extraGroups = [ "input" ];
    };

  };
}
