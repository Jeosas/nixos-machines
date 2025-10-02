{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption getExe;

  cfg = config.${namespace}.apps.bash;
in
{
  options.${namespace}.apps.bash = {
    enable = mkEnableOption "bash";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.${namespace}.user.enableHomeManager;
        message = "Home-manager is not enabled.";
      }
    ];

    ${namespace}.apps = {
      fd.enable = true;
      eza.enable = true;
      zoxide.enable = true;
    };

    environment.pathsToLink = [ "/share/bash-completion" ];

    home-manager.users.${config.${namespace}.user.name} = {
      programs = {
        fzf = {
          enable = true;
          enableBashIntegration = true;
          changeDirWidgetCommand = "${getExe pkgs.fd} --type d";
          fileWidgetCommand = "${getExe pkgs.fd} --type f";
        };
        bash = {
          enable = true;
          enableCompletion = true;
          enableVteIntegration = true;
          historyControl = [
            "erasedups"
            "ignoredups"
            "ignorespace"
          ];
          shellOptions = [
            "histappend"
          ];
          sessionVariables = {
            PATH = "$HOME/.local/bin:$PATH";
          };
          shellAliases = {
            ls = "${getExe pkgs.eza}";
            la = "${getExe pkgs.eza} -al";
            tree = "${getExe pkgs.eza} -T";
            ltmp = ''${getExe pkgs.fd} --one-file-system --base-directory / --type f --hidden --exclude "{tmp,etc/passwd,home/jeosas/.cache}"'';
            "~" = "cd ~";
            ".." = "cd ..";
            "..." = "cd ../..";
            "...." = "cd ../../..";
            "....." = "cd ../../../..";
            "......" = "cd ../../../../..";
          };
          bashrcExtra = ''
            # function commands
            jqfind () {
                ${pkgs.jq}/bin/jq '{"path": ([path(.. | select('$1'))|map(if type=="number" then "[\(.)]" else tostring end)|join(".")|split(".[]")|join("[]")]|unique|map("."+.)|.[]), "value": (.. | select('$1'))}'
            }

            # Sync bach history across terminal windows
            PROMPT_COMMAND="''${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
          '';
        };
      };
    };
  };
}
