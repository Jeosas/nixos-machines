{...}: {
  programs.zsh.shellAliases = {
    onegaishimasu = "just --unstable -f ~/.setup/justfile -d ~/.setup \"$@\"";
  };
}
