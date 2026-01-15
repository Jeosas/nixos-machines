{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.obs;
in
{
  options.${namespace}.apps.obs = with lib.types; {
    enable = mkEnableOption "OBS";
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [
        (pkgs.wrapOBS {
          plugins = with pkgs.obs-studio-plugins; [
            obs-backgroundremoval
            obs-pipewire-audio-capture
          ];
        })
      ];

      persistence.main.users.${config.${namespace}.user.name}.directories = [
        ".config/obs-studio"
      ];
    };
  };
}
