{ config, pkgs, ... }:

{
  # Git
  programs.git = {
    enable = true;

    userName = "Jeosas";
    userEmail = "jeanbaptiste@wintergerst.fr";

    extraConfig = {
      core.editor = "nvim";
      color.ui = true;
      pull.rebase = true;
      init.defaultBranch = "main";
    };

    # Pager for diff
    delta = {
      enable = true;
      options = {
        navigate = true;
        side-by-side = true;
        line-numbers = true;
        syntax-theme = "Nord";
      };
    };
  };
  programs.zsh.shellAliases.git-clean-branches = "git fetch --all --prune && git branch | grep -v '^[\\*\\+]' | xargs git branch -D";

  # Lazygit
  programs.lazygit = {
    enable = true;
    settings = {
      os.editCommand = "nvim";
      gui.showIcons = true;
    };
  };
  programs.zsh.shellAliases.lz = "lazygit";

  # dependencies
  programs.neovim.enable = true;
}
