{
  pkgs,
  namespace,
  ...
}:
{
  config = {
    environment.systemPackages = with pkgs; [ fuzzel ];

    ${namespace} = {
      apps.stow.groups = [ "fuzzel" ];
    };
  };
}
