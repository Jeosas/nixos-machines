{
  inputs,
  lib,
  namespace,
}@args:
let
  mkServer = lib.${namespace}.mkHost args { inherit (inputs) nixpkgs; };
  mkServer' =
    system: systemConfigPath:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = args;
      modules = [
        ../modules/nixos/server
        systemConfigPath
      ];
    };

  mkWorkstation = lib.${namespace}.mkHost args {
    nixpkgs = inputs.unstable;
    nixpkgsConfig = {
      allowUnfree = true;
    };
  };

  mkIso =
    system: path:
    inputs.unstable.lib.nixosSystem {
      inherit system;
      modules = [ path ];
    };
in
{
  oxygen = mkServer "aarch64-linux" ./server/oxygen;
  carbon = mkServer' "x86_64-linux" ./server/carbon;

  fr-jb-xps = mkWorkstation "x86_64-linux" ./workstation/fr-jb-xps;
  helium = mkWorkstation "x86_64-linux" ./workstation/helium;
  neon = mkWorkstation "x86_64-linux" ./workstation/neon;

  iso = mkIso "x86_64-linux" ./iso.nix;
}
