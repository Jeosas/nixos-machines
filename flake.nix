{
  description = "Jeosas' infrastructure and dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    nurpkgs.url = "github:nix-community/NUR";

    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixgl.url = "github:guibou/nixGL";

    arkenfox-userjs = {
      url = "github:arkenfox/user.js";
      flake = false;
    };

    # Perso
    thewinterdev-website.url = "github:Jeosas/thewinterdev.fr";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nurpkgs,
    impermanence,
    home-manager,
    nixgl,
    arkenfox-userjs,
    ...
  } @ inputs: let
    inherit (self) outputs;

    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (system: import ./pkgs nixpkgs-unstable.legacyPackages.${system});
    overlays = import ./overlays {inherit inputs;};

    nixosModules = import ./modules/nixos;

    nixosConfigurations = {
      neon = nixpkgs-unstable.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/neon/configuration.nix];
      };
      helium = nixpkgs-unstable.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/helium/configuration.nix];
      };
      oxygen = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          ./hosts/oxygen/configuration.nix
        ];
      };
    };

    images.oxygen = self.nixosConfigurations.oxygen.config.system.build.sdImage;

    devShells = forAllSystems (system: let
      pkgs = nixpkgs-unstable.legacyPackages.${system};
    in {
      nixos-install = pkgs.mkShell {
        name = "nixos-install";
        packages = with pkgs; [nixos-install-tools];
      };
    });
  };
}
