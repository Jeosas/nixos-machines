{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
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

  outputs = { self, nixpkgs, nixpkgs-unstable, nurpkgs, home-manager, hyprland, arkenfox-userjs, ... }@inputs:
    {
      nixosConfigurations = {
        neon = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/neon/configuration.nix ];
        };
      };

      homeConfigurations = {
        "jeosas@JB-IV" = home-manager.lib.homeManagerConfiguration rec {
          extraSpecialArgs = { inherit inputs; };
          pkgs = nixpkgs-unstable.legacyPackages.x86_64-linux;
          modules = [ ./hosts/JB-IV/home.nix ];
        };
      };
    };
}
