{
  inputs,
  ...
}:
{
  imports = [
    ./_hardware.nix
    inputs.nixos-hardware.nixosModules.dell-xps-13-9310
  ];

  # Graphics
  hardware.intelgpu = {
    driver = "xe";
    vaapiDriver = "intel-media-driver";
  };

  # Battery
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
  services = {
    power-profiles-daemon.enable = false;
    thermald.enable = true;
    tlp = {
      enable = true;
      settings = {
        CPU_BOOST_ON_AC = 1;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

        START_CHARGE_THRESH_BAT0 = 70;
        STOP_CHARGE_THRESH_BAT0 = 90;
      };
    };
  };
}
