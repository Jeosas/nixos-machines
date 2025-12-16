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
        START_CHARGE_THRESH_BAT0 = 65;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
  };
}
