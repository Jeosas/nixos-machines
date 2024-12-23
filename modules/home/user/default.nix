{
  lib,
  namespace,
  osConfig ? { },
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.user;
in
{
  options.${namespace}.user = {
    name = mkOpt types.str (osConfig.${namespace}.user.name or "jeosas"
    ) "The name of the user account.";
    home = mkOpt types.str "/home/${cfg.name}" "The home directory of the user account.";
  };

  config = {
    home = {
      username = mkDefault cfg.name;
      homeDirectory = mkDefault cfg.home;
    };
  };
}
