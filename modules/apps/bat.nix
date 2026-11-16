{
  pkgs,
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.bat;
in
{
  options.${namespace}.apps.bat = {
    enable = mkEnableOption "bat";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.${namespace}.user.enableHomeManager;
        message = "Home-manager is not enabled.";
      }
    ];

    environment.systemPackages = with pkgs; [
      bat
    ];

    ${namespace} = {
      apps.stow.groups = [ "bat" ];
    };
  };
}
