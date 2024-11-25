{
  description = "Jeosas' infrastructure and dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

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

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Perso
    thewinterdev-website.url = "github:Jeosas/thewinterdev.fr";
    ongaku.url = "github:Jeosas/ongaku";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    flake-utils,
    nurpkgs,
    impermanence,
    home-manager,
    nixgl,
    arkenfox-userjs,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in
    {
      overlays.default = import ./overlay.nix {inherit inputs;};

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

      templates = {
        rust = {
          path = ./templates/rust;
          description = "Rust development environment";
        };
      };
    }
    // flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs-unstable {
        inherit system;
        overlays = [self.overlays.default];
        config = {};
      };
    in {
      checks = let
        getChecks = checkFile:
          import checkFile {inherit inputs pkgs;};
      in {
        inherit (getChecks ./pkgs/neovim-jeosas/checks.nix) testNixVim;
      };

      packages = {inherit (pkgs) neovim-jeosas;};

      devShells = {
        nixos-install = pkgs.mkShell {
          name = "nixos-install";
          packages = with pkgs; [nixos-install-tools];
        };
      };
    });
}
