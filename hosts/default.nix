{
  inputs,
  lib,
  namespace,
}@args:
let
  mkServer =
    system: systemConfigPath:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = args;
      modules = [
        ../modules/server
        systemConfigPath
      ];
    };

  mkWorkstation =
    system: systemConfigPath:
    inputs.unstable.lib.nixosSystem {
      inherit system;
      specialArgs = args // {
        lib = lib.${namespace}.extendLib inputs.unstable.lib;
      };
      modules = [
        ../modules/workstation
        systemConfigPath
      ];
    };

  mkIso =
    system: path:
    inputs.unstable.lib.nixosSystem {
      inherit system;
      modules = [
        (
          { modulesPath, ... }:
          {
            imports = [
              "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
              "${modulesPath}/installer/cd-dvd/channel.nix"
              "${modulesPath}/profiles/all-hardware.nix"
              "${modulesPath}/profiles/minimal.nix"
            ];
          }
        )
        path
      ];
    };
in
{
  oxygen = mkServer "aarch64-linux" ./server/oxygen;
  carbon = mkServer "x86_64-linux" ./server/carbon;

  fr-jb-xps = mkWorkstation "x86_64-linux" ./workstation/fr-jb-xps;
  helium = mkWorkstation "x86_64-linux" ./workstation/helium;
  neon = mkWorkstation "x86_64-linux" ./workstation/neon;

  iso = mkIso "x86_64-linux" ./iso.nix;
}
