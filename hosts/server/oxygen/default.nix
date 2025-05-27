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
    server = {
      inherit (host.network) hostName;

      mixins = {
        rpi3.enable = true;
      };
    };
  };

  system.stateVersion = "24.05";
}
