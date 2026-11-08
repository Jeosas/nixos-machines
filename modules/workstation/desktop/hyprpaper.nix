{
  pkgs,
  namespace,
  ...
}:
{
  config = {
    environment.systemPackages = with pkgs; [ hyprpaper ];

    ${namespace} = {
      apps.stow.groups = [ "hyprpaper" ];
    };
  };
}
