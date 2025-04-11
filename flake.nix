{
  description = "Jeosas' infrastructure and dotfiles";

  inputs = {
    # NixPkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    # NixPkgs unstable
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Nixos Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Git Hooks
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";

    # NixOS User Repository
    nurpkgs.url = "github:nix-community/NUR";

    # Impermanence
    impermanence.url = "github:nix-community/impermanence";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "unstable";

    # NixGL: support graphical apps on non-nixos distros
    nixgl.url = "github:guibou/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";

    # Arkenfox config
    arkenfox-userjs.url = "github:arkenfox/user.js";
    arkenfox-userjs.flake = false;

    # NixVim
    nixvim.url = "github:nix-community/nixvim/nixos-24.11";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    #  --- Perso--- // TODO: migrate in here as a monorepository
    # thewinterdev website
    thewinterdev-website.url = "github:Jeosas/thewinterdev.fr";
    thewinterdev-website.inputs.nixpkgs.follows = "nixpkgs";

    # ongaku: music library management
    ongaku.url = "github:Jeosas/ongaku";
    ongaku.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{ nixpkgs, unstable, ... }:
    let
      namespace = "jeomod";

      lib = nixpkgs.lib.extend (
        self: super: { ${namespace} = import ./lib self super { inherit namespace; }; }
      );

      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = lib.forAllSystems supportedSystems;
    in
    {
      inherit lib;

      nixosConfigurations = import ./hosts { inherit inputs lib namespace; };

      devShells = forAllSystems { inherit nixpkgs; } (pkgs: {
        install = pkgs.mkShell {
          name = "nixos-install";
          packages = with pkgs; [ nixos-install-tools ];
        };
      });

      templates = {
        rust = {
          path = ./templates/rust;
        };
      };

      formatter = forAllSystems { nixpkgs = unstable; } (pkgs: pkgs.nixfmt-rfc-style);

      checks = forAllSystems { nixpkgs = unstable; } (pkgs: {
        git-hooks = inputs.pre-commit-hooks.lib.${pkgs.system}.run {
          src = ./.;
          hooks = {
            # General
            typos.enable = true;

            # Nix
            nixfmt-rfc-style.enable = true;
            flake-checker.enable = true;
          };
        };
      });
    };
}
