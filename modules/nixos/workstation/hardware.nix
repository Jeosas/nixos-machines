{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:

let
  inherit (lib) mkEnableOption optionalAttrs;
  inherit (lib.${namespace}) mkOpt mkIf mkMerge;

  cfg = config.${namespace}.workstation.hardware;
in
{
  options.${namespace}.workstation.hardware = with lib.types; {
    ssdEnabled = mkEnableOption "Enable SSD optimisations";
    gpuVendor = mkOpt (enum [
      false
      "nvidia"
    ]) false "GPU Vendor of the system, `false` if no dGPU";
  };

  config = mkIf config.workstation.enable (mkMerge [
    {
      # network
      networking = {
        inherit (config.${namespace}.workstation) hostName;
        firewall.enable = true;

        networkmanager.enable = true;

        nameservers = [ "9.9.9.9" ];
      };
      ${namespace}.workstation.user.extraGroups = [ "networkmanager" ];

      # audio
      services = {
        pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
        };
      };
      environment.systemPackages = with pkgs; [ ncpamixer ];

      # ssd
      services.fstrim = cfg.ssdEnabled;

      # graphics
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    }
    (optionalAttrs (cfg.gpuVendor == "nvidia") {
      # graphics/nvidia
      hardware.nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.beta;
        open = true;
        modesetting.enable = true;
        nvidiaSettings = false;
      };
      services.xserver.videoDrivers = [ "nvidia" ]; # needed even for wayland
      ${namespace}.workstation.user.extraGroups = [ "video" ];
    })
  ]);
}
