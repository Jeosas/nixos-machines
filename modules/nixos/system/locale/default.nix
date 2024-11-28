{
  lib,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.system.locale;
  locale = "en_US.UTF-8";
in {
  options.${namespace}.system.locale = {enable = mkEnableOption "locale";};
  config = mkIf cfg.enable {
    i18n.defaultLocale = locale;
    home-manager.users.${config.${namespace}.user.name} = {home.language.base = locale;};
  };
}
