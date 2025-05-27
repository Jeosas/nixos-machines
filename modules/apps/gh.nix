{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.gh;
in
{
  options.${namespace}.apps.gh = {
    enable = mkEnableOption "gh";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.${namespace}.user.enableHomeManager;
        message = "Home-manager is not enabled.";
      }
    ];

    home-manager.users.${config.${namespace}.user.name} = {
      programs = {
        gh = {
          enable = true;
        };
        gh-dash = {
          enable = true;
        };
      };
    };

    ${namespace}.impermanence.userDirectories = [
      ".config/gh"
      # ".config/gh-dash"
    ];
  };
}
