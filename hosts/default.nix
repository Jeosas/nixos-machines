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

  mkServer = lib.${namespace}.flake.mkSystem args { inherit (inputs) nixpkgs; };

  mkWorkstation = lib.${namespace}.flake.mkSystem args {
    nixpkgs = inputs.unstable;
    globalModules = with inputs; [
      home-manager.nixosModules.home-manager
      impermanence.nixosModules.impermanence
    ];
    overlays = with inputs; [
      nurpkgs.overlays.default
      (final: prev: {
        inherit (inputs.ongaku.packages.${prev.system}) ongaku;
      })
    ];
  } inputs.unstable;
in
{
  oxygen = mkServer "aarch64-linux" ./server/oxygen;

  fr-jb-xps = mkWorkstation "x86_64-linux" ./workstation/fr-jb-xps;
  helium = mkWorkstation "x86_64-linux" ./workstation/helium;
  neon = mkWorkstation "x86_64-linux" ./workstation/neon;
}
