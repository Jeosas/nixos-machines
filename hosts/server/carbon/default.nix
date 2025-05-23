{
  lib,
  namespace,
  ...
}:
let
  host = lib.${namespace}.vars.hosts.carbon;
in
{
  imports = [ ./disko.nix ];

  config = {
    ${namespace} = {
      server = {
        enable = true;
        inherit (host.network) hostName;
      };
    };

    system.stateVersion = "24.05";
  };
}
