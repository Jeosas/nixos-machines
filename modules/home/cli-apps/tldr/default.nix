{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt;
  cfg = config.${namespace}.cli-apps.tldr;
in
{
  options.${namespace}.cli-apps.tldr = with lib.types; {
    enable = mkEnableOption "tldr";
    cacheDir = mkOpt string ".cache/tealdeer" "tldr pages cache directory";
  };

  config = mkIf cfg.enable {
    programs.tealdeer = {
      enable = true;
      # enableAutoUpdates = true; # weekly systemd timer
      settings = {
        directories = {
          cache_dir = "${config.home.homeDirectory}/${cfg.cacheDir}";
        };
      };
    };
  };
}
