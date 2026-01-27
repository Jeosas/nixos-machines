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
    programs.obs-studio = {
      enable = true;

      # optional Nvidia hardware acceleration
      package = pkgs.obs-studio.override {
        cudaSupport = true;
      };

      plugins = with pkgs.obs-studio-plugins; [
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
    };

    environment.persistence.main.users.${config.${namespace}.user.name}.directories = [
      ".config/obs-studio"
    ];
  };
}
