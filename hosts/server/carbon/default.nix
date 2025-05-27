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

  ${namespace} = {
    server = {
      inherit (host.network) hostName;
    };
  };

  system.stateVersion = "25.05";
}
