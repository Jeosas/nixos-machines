{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.neovim;
in
{
  options.${namespace}.apps.neovim = {
    enable = mkEnableOption "Neovim config";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.${namespace}.user.enableHomeManager;
        message = "Home-manager is not enabled.";
      }
    ];

    home-manager.users.${config.${namespace}.user.name} = {
      home = {
        packages = [ pkgs.${namespace}.neovim ];
        sessionVariables = {
          EDITOR = "nvim";
        };
      };

      programs = {
        zsh.shellAliases.nv = "nvim";
        bash.shellAliases.nv = "nvim";
      };
    };
  };
}
