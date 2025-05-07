{
  lib,
  namespace,
  ...
}:
let
  host = lib.${namespace}.vars.hosts.oxygen;
in
{
  imports = [ ./hardware.nix ];

  ${namespace} = {
    suites.base-rpi.enable = true;

    hardware.network = { inherit (host.network) hostName; };

    services.websites.portfolio = {
      enable = true;
      domain = "thewinterdev.fr";
    };
  };

  system.stateVersion = "24.05";
}
