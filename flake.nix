{
  description = "A very basic flake";

  inputs = {
    nixpkgs-stable.url = "nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    nurpkgs.url = "github:nix-community/NUR";

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    arkenfox-userjs = {
      url = "github:arkenfox/user.js";
      flake = false;
    };
  };

  outputs = { self, nixpkgs-stable, nixpkgs-unstable, nurpkgs, home-manager, hyprland, arkenfox-userjs, ... }@inputs: {
    homeConfigurations.jeosas =
      let
        username = "jeosas";
        homeDirectory = "/home/${username}";
        configHome = "${homeDirectory}/.config";
      in
      home-manager.lib.homeManagerConfiguration rec {
        extraSpecialArgs = {
          inherit inputs;
          nvidia = true;
        };

        pkgs = import nixpkgs-unstable {
          system = "x86_64-linux";
          config.allowUnfree = false;
          config.xdg.configHome = configHome;
          overlays = [
            nurpkgs.overlay
          ];
        };

        modules = [
          inputs.hyprland.homeManagerModules.default
          inputs.nurpkgs.hmModules.nur
          {
            home = {
              inherit username homeDirectory;
              stateVersion = "23.11"; # a.k.a. unstable

              packages = with pkgs; [
                edgedb
              ];
            };

            programs.home-manager.enable = true;
          }
          ./dotfiles/git.nix
          ./dotfiles/zsh.nix
          ./dotfiles/neofetch.nix
          ./dotfiles/starship.nix
          ./dotfiles/neovim
          ./dotfiles/direnv.nix
          ./dotfiles/firefox.nix
          ./dotfiles/de/hyprland
        ];
      };
    homeConfigurations.jb =
      let
        username = "jb";
        homeDirectory = "/home/${username}";
        configHome = "${homeDirectory}/.config";
      in
      home-manager.lib.homeManagerConfiguration rec {
        extraSpecialArgs = {
          inherit inputs;
          nvidia = true;
        };

        pkgs = import nixpkgs-unstable {
          system = "x86_64-linux";
          config.allowUnfree = false;
          config.xdg.configHome = configHome;
        };

        modules = [
          {
            home = {
              inherit username homeDirectory;
              stateVersion = "23.11"; # a.k.a. unstable

              # packages = with pkgs; [];
            };

            programs.home-manager.enable = true;
          }
          ./dotfiles/neovim
        ];
      };
  };
}
