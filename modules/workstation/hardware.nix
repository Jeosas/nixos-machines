{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:

let
  inherit (lib) mkEnableOption mkMerge mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.workstation.hardware;
in
{
  options.${namespace}.workstation.hardware = with lib.types; {
    enableSSD = mkEnableOption "Enable SSD optimisations";
    enableLaptopUtils = mkEnableOption "Enable laptop tools such as backlight.";
    enableBluetooth = mkEnableOption "Enable bluetooth support";
    gpuVendor = mkOpt (enum [
      false
      "nvidia"
    ]) false "GPU Vendor of the system, `false` if no dGPU";
  };

  config = mkMerge [
    {
      # network
      networking = {
        inherit (config.${namespace}.workstation) hostName;
        firewall.enable = true;

        networkmanager.enable = true;

        nameservers = [ "9.9.9.9" ];
      };
      ${namespace}.user.extraGroups = [ "networkmanager" ];

      # audio
      services = {
        pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
        };
      };
      environment.systemPackages = with pkgs; [ wiremix ];

      # ssd
      services.fstrim.enable = cfg.enableSSD;

      # graphics
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    }
    (mkIf (cfg.gpuVendor == "nvidia") {
      # graphics/nvidia
      hardware.nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.beta;
        open = true;
        modesetting.enable = true;
        nvidiaSettings = false;
      };
      services.xserver.videoDrivers = [ "nvidia" ]; # needed even for wayland
      ${namespace}.user.extraGroups = [ "video" ];
    })
    (mkIf cfg.enableLaptopUtils {
      programs.light.enable = true;
      ${namespace}.user.extraGroups = [ "video" ];
    })
    (mkIf cfg.enableBluetooth {
      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = false;
      environment.systemPackages = with pkgs; [ bluetuith ];
    })
  ];
}
