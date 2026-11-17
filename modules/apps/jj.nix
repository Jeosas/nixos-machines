{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.jj;
in
with lib;
{
  options.${namespace}.apps.jj = {
    enable = mkEnableOption "jj";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.${namespace}.user.enableHomeManager;
        message = "Home-manager is not enabled.";
      }
    ];

    environment.systemPackages = with pkgs; [
      jujutsu
    ];

    ${namespace} = {
      apps.git.enable = true;
      apps.stow.groups = [ "jj" ];
    };
  };
}
