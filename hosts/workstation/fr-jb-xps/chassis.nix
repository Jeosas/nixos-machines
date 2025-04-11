{ inputs, ... }:
{
  imports = [ inputs.nixos-hardware.nixosModules.dell-xps-13-9310 ];

  config = {
    hardware.intelgpu = {
      driver = "xe";
      vaapiDriver = "intel-media-driver";
    };
  };
}
