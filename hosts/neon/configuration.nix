{ pkgs, lib, config, inputs, ... }:

{
  imports = [
    ./vm.nix

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.jeosas = import ./home.nix { inherit config pkgs inputs; };
      home-manager.extraSpecialArgs = { inherit inputs; };
    }
  ];

  # Nix
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
  nixpkgs = {
    hostPlatform = "x86_64-linux";
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
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Graphics
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };
  programs.hyprland.enable = true;

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
        users = [ "jeosas" ];
        persist = true;
      }
    ];
  };
  security.polkit.enable = true;

  # Users
  users.mutableUsers = false;
  users.users.jeosas = {
    isNormalUser = true;
    initialPassword = "jeosas";
    description = "jeosas";
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;
}
