{
  config,
  lib,
  inputs,
  outputs,
  ...
}: let
  cfg = config.jeomod.system.nix;
in
  with lib; {
    options.jeomod.system.nix = {
      allowUnfree = mkOption {
        type = types.bool;
        description = "Allow Unfree packages";
        default = false;
      };
    };

    config = {
      nixpkgs = {
        overlays = [
          inputs.nurpkgs.overlay
          outputs.overlays.additions
          outputs.overlays.discord-latest # Fix outdated discord on nixpkgs
          outputs.overlays.fixes._7zz
        ];
        config = {
          inherit (cfg) allowUnfree;
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
    };
  }
