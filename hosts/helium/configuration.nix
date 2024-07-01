{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    ./hardware.nix
    ./battery.nix
    ../../home/tools/houseKeeping.nix

    ./remove_me.nix

    inputs.impermanence.nixosModules.impermanence
    ./impermanence.nix
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.jeosas = import ./home.nix {inherit config pkgs inputs;};
      home-manager.extraSpecialArgs = {inherit inputs;};
    }
  ];

  # System Emulation
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Nix
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
  nixpkgs = {
    overlays = [
      inputs.nurpkgs.overlay
    ];
    config = {
      allowUnfree = true;
    };
  };
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  # Locales
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Firmeare update software
  services.fwupd.enable = true;

  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # SSD
  services.fstrim.enable = true;

  # Trackpoint
  hardware.trackpoint.enable = true;
  hardware.trackpoint.emulateWheel = true;

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Fonts - leave user (home-manager) setup fonts
  fonts.enableDefaultPackages = false;

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Network
  networking.networkmanager.enable = true;
  networking.hostName = "helium";
  networking.firewall.enable = false;

  # Audio
  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Admin
  security.sudo.enable = false;
  security.doas = {
    enable = true;
    extraRules = [
      {
        users = ["jeosas"];
        persist = true;
      }
    ];
  };
  security.polkit.enable = true;

  # for Kmonad
  hardware.uinput.enable = true;

  # backlight
  programs.light.enable = true;

  # usb automount
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    tree
  ];

  fonts.packages = with pkgs; [
    # Fonts
    mplus-outline-fonts.githubRelease # normal + cjk font
    openmoji-color # emoji
    (nerdfonts.override {fonts = ["MPlus"];}) # nerdfonts

    # Windaube fonts for compat
    corefonts
    vistafonts

    # Cursor
    nordzy-cursor-theme
  ];

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  programs.adb.enable = true;

  # Users
  users.mutableUsers = false;
  users.users.jeosas = {
    isNormalUser = true;
    hashedPasswordFile = "/persist/jeosas-password";
    description = "jeosas";
    extraGroups = ["wheel" "networkmanager" "video" "input" "uinput" "adbusers" "kvm"];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;
}
