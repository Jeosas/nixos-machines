{
  lib,
  pkgs,
  inputs,
  system,
  namespace,
  ...
}:
inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
  inherit pkgs;
  module =
    { ... }:
    {
      imports = lib.${namespace}.getNonDefaultNixFilesRecursive ./.;
    };
  extraSpecialArgs = { };
}
