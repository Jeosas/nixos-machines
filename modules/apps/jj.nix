{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.jj;
in
with lib;
{
  options.${namespace}.apps.jj = {
    enable = mkEnableOption "jj";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.${namespace}.user.enableHomeManager;
        message = "Home-manager is not enabled.";
      }
    ];

    ${namespace}.apps.git.enable = true;

    home-manager.users.${config.${namespace}.user.name} = {
      home.packages = with pkgs; [
        lazyjj
      ];

      programs = {
        jujutsu = {
          enable = true;
          settings = {
            user = {
              email = config.${namespace}.apps.git.userEmail;
              name = config.${namespace}.apps.git.userName;
            };
            ui = {
              paginate = "never";
              default-command = [ "log" ];
            };
            revset-aliases = {
              "closest_bookmark(to)" = "heads(::to & bookmarks())";
            };
            aliases = {
              tug = [
                "bookmark"
                "move"
                "--from"
                "closest_bookmark(@-)"
                "--to"
                "@-"
              ];
              pre-commit = [
                "util"
                "exec"
                "--"
                "bash"
                "-c"
                ''
                  jj diff -f ''${1:-'@-'} -t ''${2:-'@'} --name-only --no-pager | xargs pre-commit run --files
                ''
                ""
              ];
            };
          };
        };
        zsh.shellAliases = {
          lj = "lazyjj";
        };
        bash.shellAliases = {
          lj = "lazyjj";
        };
      };
    };
  };
}
