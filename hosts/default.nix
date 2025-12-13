{
  inputs,
  lib,
  namespace,
}@args:
let
  mkServerLegacy =
    system: systemConfigPath:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = args;
      modules = [
        ../modules/server-legacy
        systemConfigPath
      ];
    };

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
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = args // {
        lib = lib.${namespace}.extendLib inputs.nixpkgs.lib;
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
  oxygen = mkServerLegacy "aarch64-linux" ./server/oxygen;
  carbon = mkServer "x86_64-linux" ./server/carbon;

  helium = mkWorkstation "x86_64-linux" ./workstation/helium;
  neon = mkWorkstation "x86_64-linux" ./workstation/neon;

  iso = mkIso "x86_64-linux" ./iso.nix;
}
