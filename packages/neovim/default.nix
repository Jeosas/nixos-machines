{
  lib,
  pkgs,
  inputs,
  stdenv,
  namespace,
  ...
}:
inputs.nixvim.legacyPackages.${stdenv.hostPlatform.system}.makeNixvimWithModule {
  inherit pkgs;
  module =
    { ... }:
    {
      imports = lib.${namespace}.getNonDefaultNixFilesRecursive ./.;
    };
  extraSpecialArgs = {
    inherit namespace;
  };
}
