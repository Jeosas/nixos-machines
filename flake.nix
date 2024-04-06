{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    nurpkgs.url = "github:nix-community/NUR";

    deploy-rs.url = "github:serokell/deploy-rs";

    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixgl.url = "github:guibou/nixGL";

    hyprland.url = "github:hyprwm/Hyprland";
    arkenfox-userjs = {
      url = "github:arkenfox/user.js";
      flake = false;
    };

    # Perso
    thewinterdev-website.url = "github:Jeosas/thewinterdev.fr";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nurpkgs, deploy-rs, impermanence, home-manager, nixgl, hyprland, arkenfox-userjs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs-unstable.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        neon = nixpkgs.lib.nixosSystem { specialArgs = { inherit inputs; }; modules = [ ./hosts/neon/configuration.nix ]; };
        helium = nixpkgs.lib.nixosSystem { specialArgs = { inherit inputs; }; modules = [ ./hosts/helium/configuration.nix ]; };
        oxygen = nixpkgs.lib.nixosSystem { 
          system = "aarch64-linux"; 
          specialArgs = { inherit inputs; };
          modules = [ 
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            ./hosts/oxygen/configuration.nix 
          ];
        };
      };

      homeConfigurations = {
        "jeosas@JB-IV" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./hosts/JB-IV/home.nix ];
        };
        "jb@fr-jb-xps" = import (./. + "/hosts/jb@fr-jb-xps") { inherit inputs pkgs; };
      };

      images.oxygen = self.nixosConfigurations.oxygen.config.system.build.sdImage;

      devShells.${system} = {
        default = self.devShells.${system}.deploy;
        deploy  = pkgs.mkShell {
          name = "deploy";
          packages = [ pkgs.deploy-rs ];
        };
        nixos-install = pkgs.mkShell {
          name = "nixos-install";
          packages = with pkgs; [ nixos-install-tools ];
        };
      };

      deploy = {
        nodes = {
          oxygen = {
            hostname = "oxygen";
            profiles = {
              system = {
                sshUser = "root";
                path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.oxygen;
              };
            };
          };
        };
      };

      # Check deployment definitions.
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
