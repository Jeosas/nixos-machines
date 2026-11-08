{
  pkgs,
  namespace,
  ...
}:
{
  config = {
    environment.systemPackages = with pkgs; [ waybar ];

    ${namespace} = {
      apps.stow.groups = [ "waybar" ];
    };
  };
}
