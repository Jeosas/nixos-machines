{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.jeomod.system.audio;
in
  with lib; {
    options.jeomod.system.audio = {
      enable = mkEnableOption "Audio";
    };

    config = mkIf cfg.enable {
      hardware.pulseaudio.enable = false;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
      environment.systemPackages = with pkgs; [ncpamixer];
    };
  }
