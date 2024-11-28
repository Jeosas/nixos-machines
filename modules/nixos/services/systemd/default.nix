{
  namespace,
  config,
  ...
}: {
  config = {
    home-manager.users.${config.${namespace}.user.name} = {
      # Nicely reload system units when changing configs
      systemd.user = {
        enable = true;
        startServices = "sd-switch";
      };
    };
  };
}
