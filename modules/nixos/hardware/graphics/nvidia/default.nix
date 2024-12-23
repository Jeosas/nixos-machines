{
  lib,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.hardware.graphics.nvidia;
in
with lib;
{
  options.${namespace}.hardware.graphics.nvidia = {
    enable = mkEnableOption "Nvidia drivers";
  };

  config = mkIf cfg.enable {
    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      open = true;
      modesetting.enable = true;
      nvidiaSettings = false;
    };
    services.xserver.videoDrivers = [ "nvidia" ]; # needed even for wayland
    ${namespace}.user.extraGroups = [ "video" ];
  };
}
