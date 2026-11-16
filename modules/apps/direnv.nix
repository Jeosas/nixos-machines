{
  pkgs,
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.apps.direnv;
in
{
  options.${namespace}.apps.direnv = {
    enable = mkEnableOption "direnv";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.${namespace}.user.enableHomeManager;
        message = "Home-manager is not enabled.";
      }
    ];

    environment.systemPackages = with pkgs; [
      direnv
    ];

    ${namespace} = {
      apps.stow.groups = [ "direnv" ];
    };

    environment.persistence.main.users.${config.${namespace}.user.name}.directories = [
      ".local/share/direnv/allow"
    ];
  };
}
