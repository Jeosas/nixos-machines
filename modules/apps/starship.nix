{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.starship;
in
{
  options.${namespace}.apps.starship = {
    enable = mkEnableOption "starship";
  };
  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.${namespace}.user.enableHomeManager;
        message = "Home-manager is not enabled.";
      }
    ];

    home-manager.users.${config.${namespace}.user.name} = {
      programs.starship = {
        enable = true;
        enableZshIntegration = config.${namespace}.apps.zsh.enable;
        enableBashIntegration = config.${namespace}.apps.bash.enable;
        settings = {
          format = ''
            $username[@](white)$hostname$nix_shell''${custom.jj}$git_branch$python$rust
            $sudo$directory$battery$status$character'';

          directory = {
            format = "[$path ]($style)";
            truncation_length = 4;
            truncation_symbol = "_/";
          };

          battery = {
            format = "[$symbol]($style)";
            display = [
              {
                threshold = 30;
                style = "yellow";
              }
              {
                threshold = 10;
                style = "red";
              }
            ];
          };

          username = {
            show_always = true;
            format = "[$user]($style)";
            style_user = "white";
            style_root = "red";
          };

          hostname = {
            format = "[$hostname](white)";
            trim_at = ".";
            ssh_only = false;
          };

          nix_shell = {
            format = "\\[[$symbol$state( \\($name\\))]($style)\\]";
            symbol = " ";
          };

          git_branch = {
            format = "\\[[$symbol$branch]($style)\\]";
            only_attached = true;
          };

          python.format = ''\[[''${symbol}''${pyenv_prefix}(''${version})(\($virtualenv\))]($style)\]'';

          rust.format = "\\[[$symbol($version)]($style)\\]";

          sudo.format = "[󱑷](bold yellow)";

          custom.jj = {
            disabled = false;
            command = ''d=$(jj log --no-graph -T 'description.first_line()' -r @); test -n "$d" && echo $d || echo "(no desc)"'';
            when = "jj st";
            format = "\\[[$symbol($output)]($style)\\]";
            symbol = " ";
            style = "bold purple";
            require_repo = true;
            detect_folders = [ ".jj" ];
          };
        };
      };
    };
  };
}
