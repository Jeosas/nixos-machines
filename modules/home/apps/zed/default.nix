{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkOpt';

  cfg = config.${namespace}.apps.zed;
in
{
  options.${namespace}.apps.zed = with lib.types; {
    enable = mkEnableOption "zed";
    ai-model = mkOpt' string "";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ nixd ];

    programs.zed-editor = {
      enable = true;
      # extensions = [ "nix" ];
      # extraPackages = with pkgs; [
      #   nixd
      # ];
      userKeymaps = [ ];
      userSettings = {
        features = {
          copilot = false;
        };
        telemetry = {
          metrics = false;
        };
        vim_mode = true;
        ui_font_size = 16;
        buffer_font_size = 16;
      };
    };
  };
}
