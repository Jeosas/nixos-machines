{
  lib,
  pkgs,
  namespace,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.yazi;
in
{
  options.${namespace}.apps.yazi = {
    enable = mkEnableOption "yazi";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.${namespace}.user.enableHomeManager;
        message = "Home-manager is not enabled.";
      }
    ];

    ${namespace} = {
      apps.stow.groups = [ "yazi" ];
    };

    home-manager.users.${config.${namespace}.user.name} = {
      programs.yazi = {
        enable = true;
        package = pkgs.unstable.yazi;
        enableZshIntegration = config.${namespace}.apps.zsh.enable;
        enableBashIntegration = config.${namespace}.apps.bash.enable;
        shellWrapperName = "yy";
      };
    };
  };
}
