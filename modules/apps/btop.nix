{
  pkgs,
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.btop;
in
{
  options.${namespace}.apps.btop = {
    enable = mkEnableOption "btop";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.${namespace}.user.enableHomeManager;
        message = "Home-manager is not enabled.";
      }
    ];

    environment.systemPackages = with pkgs; [
      btop
    ];

    ${namespace} = {
      apps.stow.groups = [ "btop" ];
    };
  };
}
