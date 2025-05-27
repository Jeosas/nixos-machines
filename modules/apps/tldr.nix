{
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
      assertions = [
        {
          assertion = config.${namespace}.user.enableHomeManager;
          message = "Home-manager is not enabled.";
        }
      ];

      home-manager.users.${config.${namespace}.user.name} = {
        programs.tealdeer = {
          enable = true;
          enableAutoUpdates = true; # weekly systemd timer
          settings = {
            directories = {
              cache_dir = "${config.${namespace}.user.home}/${cacheDir}";
            };
          };
        };
      };

      ${namespace}.impermanence.userDirectories = [ cacheDir ];
    };
}
