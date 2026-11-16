{
  pkgs,
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.fastfetch;
in
{
  options.${namespace}.apps.fastfetch = {
    enable = mkEnableOption "fastfetch";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      fastfetch
      lolcat
      figlet
    ];

    ${namespace} = {
      apps.stow.groups = [ "fastfetch" ];
    };
  };
}
