{
  pkgs,
  namespace,
  ...
}:
{
  config = {
    environment.systemPackages = [
      pkgs.noctalia-shell
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
