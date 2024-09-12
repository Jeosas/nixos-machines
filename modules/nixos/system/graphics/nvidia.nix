{
  config,
  lib,
  ...
}: let
  cfg = config.jeomod.system.graphics.nvidia;
in
  with lib; {
    options.jeomod.system.graphics.nvidia = {
      enable = mkEnableOption "Nvidia drivers";
    };

    config = mkIf cfg.enable {
      hardware.nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.beta;
        open = true;
        modesetting.enable = true;
        nvidiaSettings = false;
      };
      services.xserver.videoDrivers = ["nvidia"]; # needed even for wayland
      jeomod.groups = ["video"];
    };
  }
