{ config, pkgs, lib, ... }:

let
  inherit (lib) mkDefault;
in
{
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
      os.editCommand = "nvim";
      os.disableStartupPopups = true;
      gui.nerdFontsVersion = "3"; # show icons
      gui.mouseEvents = false;
    };
  };
  programs.zsh.shellAliases.lz = "lazygit";

  # dependencies
  programs.neovim.enable = true;
}
