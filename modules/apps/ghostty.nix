{
  pkgs,
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.ghostty;
in
{
  options.${namespace}.apps.ghostty = {
    enable = mkEnableOption "ghostty";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.${namespace}.user.enableHomeManager;
        message = "Home-manager is not enabled.";
      }
    ];

    environment.systemPackages = with pkgs; [
      ghostty
    ];

    ${namespace} = {
      apps.stow.groups = [ "ghostty" ];
    };
  };
}
