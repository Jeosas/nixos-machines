{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.bash;
in
{
  options.${namespace}.apps.bash = {
    enable = mkEnableOption "bash";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.${namespace}.user.enableHomeManager;
        message = "Home-manager is not enabled.";
      }
    ];

    environment.systemPackages = with pkgs; [
      bash
      fzf
      fd
      eza
    ];

    ${namespace} = {
      apps.stow.groups = [
        "profile"
        "bash"
      ];
    };
  };
}
