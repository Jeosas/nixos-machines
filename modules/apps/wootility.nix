{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.wootility;
in
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
