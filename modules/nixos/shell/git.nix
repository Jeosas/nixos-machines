{
  config,
  lib,
  ...
}: let
  cfg = config.jeomod.git;
in
  with lib; {
    options.jeomod.git = {
      userName = mkOption {
        type = types.str;
        description = "Git user name";
        default = "Jeosas";
      };
      userEmail = mkOption {
        type = types.str;
        description = "Git user email";
        default = "jeanbaptiste@wintergerst.fr";
      };
    };

    config = {
      home-manager.users.${config.jeomod.user} = {
        # dependencies
        programs.neovim.enable = true;

        # Git
        programs.git = {
          enable = true;

          inherit (cfg) userName userEmail;

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
      };
    };
  }
