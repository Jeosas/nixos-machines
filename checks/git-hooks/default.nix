{ inputs, system, ... }:

inputs.pre-commit-hooks.lib.${system}.run {
  src = ./.;
  hooks = {
    # General
    typos.enable = true;

    # Nix
    nixfmt-rfc-style.enable = true;
    flake-checker.enable = true;
  };
}
