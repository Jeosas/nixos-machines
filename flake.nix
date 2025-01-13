{
  description = "Jeosas' infrastructure and dotfiles";

  inputs = {
    # NixPkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    # NixPkgs unstable
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Nixos Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Snowfall lib: flake management
    snowfall-lib.url = "github:snowfallorg/lib";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";

    # NixOS User Repository
    nurpkgs.url = "github:nix-community/NUR";

    # Impermanence
    impermanence.url = "github:nix-community/impermanence";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

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
    inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;

        snowfall = {
          meta = {
            name = "jeosas-config";
            title = "Jeosas' config";
          };

          namespace = "jeomod";
        };
      };
    in
    lib.mkFlake {
      channels-config = {
        allowUnfree = true;
      };

      overlays = with inputs; [ nurpkgs.overlays.default ];

      systems.modules.nixos = with inputs; [
        home-manager.nixosModules.home-manager
        impermanence.nixosModules.impermanence
      ];

      homes.modules = with inputs; [ impermanence.homeManagerModules.impermanence ];

      templates = {
        rust.description = "Rust development environment";
      };

      outputs-builder = channels: {
        formatter = channels.nixpkgs.nixfmt-rfc-style;
      };
    }
    // {
      inherit (inputs) self;
    };
}
