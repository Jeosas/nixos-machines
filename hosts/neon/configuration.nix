{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    ./hardware.nix
    ../../home/tools/houseKeeping.nix

    inputs.impermanence.nixosModules.impermanence
    ./impermanence.nix
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.jeosas = import ./home.nix {inherit config pkgs inputs;};
      home-manager.extraSpecialArgs = {inherit inputs;};
    }
    ./gaming.nix
    ./game_dev.nix
  ];

  # System Emulation
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_6_8;

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
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  # Locales
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Nvidia
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    open = false;
    modesetting.enable = true;
    nvidiaSettings = false;
  };
  services.xserver.videoDrivers = ["nvidia"]; # needed even for wayland

  # SSD
  services.fstrim.enable = true;

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
  networking.hostName = "neon";
  networking.firewall.enable = false;

  # Audio
  sound.enable = true;
  hardware.pulseaudio.enable = false;
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

  # Users
  users.mutableUsers = false;
  users.users.jeosas = {
    isNormalUser = true;
    hashedPasswordFile = "/persist/jeosas-password";
    description = "jeosas";
    extraGroups = [
      "wheel" # admin
      "networkmanager" # network
      "video" # nvidia
      "kvm" # android avd
    ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  programs.ssh.extraConfig = ''
    Host *
      AddkeysToAgent yes
      Identitiesonly yes

    Host github.com
      HostName      github.com
      IdentityFile  ~/.ssh/id_github
      User          git
  '';
}
