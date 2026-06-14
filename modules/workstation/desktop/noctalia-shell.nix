{
  pkgs,
  namespace,
  ...
}:
{
  config = {
    environment.systemPackages = [
      pkgs.unstable.noctalia-shell
    ];

    services.upower = {
      enable = true;
    };

    ${namespace} = {
      apps.stow.groups = [
        "noctalia-shell"
      ];
    };
  };
}
