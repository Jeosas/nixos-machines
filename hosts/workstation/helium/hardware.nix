{
  _,
  ...
}:
{
  imports = [ ./_hardware.nix ];

  # Firmware update software
  services.fwupd.enable = true;

  # Trackpoint
  hardware = {
    trackpoint = {
      enable = true;
      emulateWheel = true;
    };
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
        CPU_SCALING_GOVERNOR_ON_AC = "ondemand";
        CPU_DRIVER_OPMODE_ON_AC = "passive";
        PLATFORM_PROFILE_ON_AC = "balanced";

        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_BAT = "conservative";
        CPU_DRIVER_OPMODE_ON_BAT = "passive";
        PLATFORM_PROFILE_ON_BAT = "low-power";

        START_CHARGE_THRESH_BAT0 = 65;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
  };
}
