{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.neovim;
in
with lib;
{
  options.${namespace}.cli-apps.neovim = {
    enable = mkEnableOption "Neovim config";
  };

  config = mkIf cfg.enable {
    home = {
      packages = [ pkgs.${namespace}.neovim ];
      sessionVariables = {
        EDITOR = "nvim";
      };
    };

    programs.zsh.shellAliases.nv = "nvim";
  };
}
