{
  namespace,
  ...
}:
{
  config = {
    services.dunst = {
      enable = true;
      enableWayland = true;
    };

    ${namespace} = {
      apps.stow.groups = [ "dunst" ];
    };
  };
}
