{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Audio
    pipewore
    pulseaudio
    wireplumber

    # Network
    networkmanager
  ];
}
