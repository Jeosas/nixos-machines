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
      fetch.prune = true;
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

  # Lazygit
  programs.lazygit = {
    enable = true;
    settings = {
      os.editCommand = "nvim";
      gui.nerdFontsVersion = "3"; # show icons
    };
  };
  programs.zsh.shellAliases.lz = "lazygit";

  # dependencies
  programs.neovim.enable = true;
}
