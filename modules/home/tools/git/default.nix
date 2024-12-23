{
  lib,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.tools.git;
in
with lib;
with lib.${namespace};
{
  options.${namespace}.tools.git = with types; {
    enable = mkEnableOption "git";
    userName = mkOpt str "Jeosas" "Git user name";
    userEmail = mkOpt str "jeanbaptiste@wintergerst.fr" "Git user email";
  };

  config = mkIf cfg.enable {
    # Git
    programs.git = {
      enable = true;

      inherit (cfg) userName userEmail;

      extraConfig = {
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
        gui.nerdFontsVersion = "3"; # show icons
        gui.mouseEvents = false;
      };
    };
    programs.zsh.shellAliases = {
      lz = "lazygit";
      fastcommit = ''git add -A; git commit -a -m "`curl -s https://whatthecommit.com/index.txt`"'';
    };
  };
}
