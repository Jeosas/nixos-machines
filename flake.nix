{
  description = "A very basic flake";

  inputs = {
    nixpkgs-stable.url = "nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs-stable, nixpkgs-unstable, home-manager, hyprland, ... }@inputs: {
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
        };

        modules = [
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
          ./dotfiles/starship.nix
          ./dotfiles/neovim
          ./dotfiles/direnv
          inputs.hyprland.homeManagerModules.default
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
