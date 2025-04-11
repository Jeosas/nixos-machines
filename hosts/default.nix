{
  inputs,
  lib,
  namespace,
}@args_:
let
  hosts = import ./hosts.nix;

  args = args_ // {
    inherit hosts;
  };

  mkServer = lib.${namespace}.mkHost args { inherit (inputs) nixpkgs; };
  mkWorkstation = lib.${namespace}.mkHost args {
    inherit (inputs) nixpkgs;
    nixpkgsConfig = {
      allowUnfree = true;
    };
  };
in
{
  oxygen = mkServer "aarch64-linux" ./server/oxygen;

  fr-jb-xps = mkWorkstation "x86_64-linux" ./workstation/fr-jb-xps;
  helium = mkWorkstation "x86_64-linux" ./workstation/helium;
  neon = mkWorkstation "x86_64-linux" ./workstation/neon;
}
