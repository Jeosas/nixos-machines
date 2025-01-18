{
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) enabled;
  hostInfo = (import ../../../hosts.nix).oxygen;
in
{
  imports = [ ./hardware.nix ];

  ${namespace} = {
    suites.base-rpi = enabled;

    hardware.network = { inherit (hostInfo) hostName; };

    services.websites.portfolio = {
      enable = true;
      domain = "thewinterdev.fr";
    };
  };

  system.stateVersion = "24.05";
}
