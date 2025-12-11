{
  lib,
  namespace,
  inputs,
  ...
}:
let
  host = lib.${namespace}.vars.hosts.oxygen;
in
{
  imports = [
    ./hardware.nix
    ./www/thewinterdev_fr.nix
    ./www/innovlens-fr.nix
    ./www/postgres.nix
  ];

  ${namespace} = {
    server-legacy = {
      inherit (host.network) hostName;
      impermanenceEnabled = false;

      mixins = {
        rpi3.enable = true;
      };
    };

    services = {
      goatcounter.enable = true;
    };
  };

  nixpkgs.overlays = [
    inputs.innovlens.overlays.innovlens
  ];

  system.stateVersion = "24.05";
}
