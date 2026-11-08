{
  pkgs,
  namespace,
  ...
}:
{
  config = {
    environment.systemPackages = with pkgs; [ wofi ];

    ${namespace} = {
      apps.stow.groups = [ "wofi" ];
    };
  };
}
