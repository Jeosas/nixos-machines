{
  namespace,
  hosts,
  ...
}:
{
  imports = [ ./hardware.nix ];

  ${namespace} = {
    suites.base-rpi.enable = true;

    hardware.network = { inherit (hosts.oxygen) hostName; };

    services.websites.portfolio = {
      enable = true;
      domain = "thewinterdev.fr";
    };
  };

  system.stateVersion = "24.05";
}
