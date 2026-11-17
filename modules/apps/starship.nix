{
  pkgs,
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.starship;
in
{
  options.${namespace}.apps.starship = {
    enable = mkEnableOption "starship";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      starship
    ];

    ${namespace} = {
      apps.stow.groups = [ "starship" ];
    };
  };
}
