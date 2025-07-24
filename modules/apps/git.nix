{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.apps.git;
in
{
  options.${namespace}.apps.git = with lib.types; {
    enable = mkEnableOption "git";
    userName = mkOpt str "Jeosas" "Git user name";
    userEmail = mkOpt str "jeanbaptiste@wintergerst.fr" "Git user email";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.${namespace}.user.enableHomeManager;
        message = "Home-manager is not enabled.";
      }
    ];

    home-manager.users.${config.${namespace}.user.name} = {
      programs = {
        git = {
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

        lazygit = {
          enable = true;
          settings = {
            notARepository = "skip";
            disableStartupPopups = true;
            gui.nerdFontsVersion = "3"; # show icons
            gui.mouseEvents = false;
          };
        };

        zsh.shellAliases = {
          lz = "lazygit";
          fastcommit = ''git add -A; git commit -a -m "`curl -s https://whatthecommit.com/index.txt`"'';
        };

        bash.shellAliases = {
          lz = "lazygit";
          fastcommit = ''git add -A; git commit -a -m "`curl -s https://whatthecommit.com/index.txt`"'';
        };
      };
    };
  };
}
