{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.hardware.audio;
in
with lib;
{
  options.${namespace}.hardware.audio = {
    enable = mkEnableOption "audio";
  };

  config = mkIf cfg.enable {
    services = {
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
    };
    environment.systemPackages = with pkgs; [ ncpamixer ];
  };
}
