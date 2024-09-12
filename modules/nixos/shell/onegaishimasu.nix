{config, ...}: {
  home-manager.users.${config.jeomod.user}.programs.zsh.shellAliases = {
    onegaishimasu = "just -f ~/.setup/justfile -d ~/.setup \"$@\"";
  };
}
