{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
in {
  # Git
  programs.git = {
    enable = true;

    userName = mkDefault "Jeosas";
    userEmail = mkDefault "jeanbaptiste@wintergerst.fr";

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
      notARepository = "skip";
      disableStartupPopups = true;
      os.edit = "nvim";
      gui.nerdFontsVersion = "3"; # show icons
      gui.mouseEvents = false;
    };
  };
  programs.zsh.shellAliases = {
    lz = "lazygit";
    fastcommit = "git add -A; git commit -a -m \"`curl -s https://whatthecommit.com/index.txt`\"";
  };

  # dependencies
  programs.neovim.enable = true;
}
