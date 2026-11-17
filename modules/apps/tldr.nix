{
  pkgs,
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.tldr;
in
{
  options.${namespace}.apps.tldr = {
    enable = mkEnableOption "tldr";
  };

  config =
    let
      cacheDir = ".cache/tealdeer";
    in
    mkIf cfg.enable {

      environment.systemPackages = with pkgs; [
        tealdeer
      ];

      ${namespace} = {
        apps.stow.groups = [ "tealdeer" ];
      };

      environment.persistence.main.users.${config.${namespace}.user.name}.directories = [
        cacheDir
      ];
    };
}
