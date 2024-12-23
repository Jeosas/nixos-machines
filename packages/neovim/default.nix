{
  lib,
  pkgs,
  inputs,
  system,
}:
inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
  inherit pkgs;
  module = {...}: {
    imports = lib.snowfall.fs.get-non-default-nix-files-recursive ./.;
  };
  extraSpecialArgs = {};
}
