{
  lib,
  namespace,
  ...
}:
let
  host = lib.${namespace}.vars.hosts.oxygen;
in
{
  imports = [
    ./hardware.nix
    ./www/thewinterdev_fr.nix
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

  system.stateVersion = "24.05";
}
