{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.apps.direnv;
in
{
  options.${namespace}.apps.direnv = {
    enable = mkEnableOption "direnv";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.${namespace}.user.enableHomeManager;
        message = "Home-manager is not enabled.";
      }
    ];

    home-manager.users.${config.${namespace}.user.name} = {
      programs.direnv = {
        enable = true;
        enableZshIntegration = config.${namespace}.apps.zsh.enable;
        enableBashIntegration = config.${namespace}.apps.bash.enable;

        nix-direnv.enable = true;
      };

      xdg.configFile."direnv/direnvrc" = {
        text =
          # bash
          ''
            layout_poetry() {
               PYPROJECT_TOML="''${PYPROJECT_TOML:-pyproject.toml}"
                if [[ ! -f "$PYPROJECT_TOML" ]]; then
                    log_stats "No pyproject.toml found. Executing \`poetry init\` to create a \`$PYPROJECT_TOML\` first."
                    poetry init
                fi

                if [[ -d ".venv" ]]; then
                    VIRTUAL_ENV="$(pwd)/.venv"
                else
                    VIRTUAL_ENV=$(poetry env info --path 2>/dev/null ; true)
                fi

                if [[ -z $VIRTUAL_ENV || ! -d $VIRTUAL_ENV ]]; then
                    log_status "No virtual environment exists. Executing \`poetry install\` to create one."
                    poetry install
                    VIRTUAL_ENV=$(poetry env info --path)
                fi

                PATH_add "$VIRTUAL_ENV/bin"
                export POETRY_ACTIVE=1
                export VIRTUAL_ENV
            }
          '';
      };
    };

    environment.persistence.main.users.${config.${namespace}.user.name}.directories = [
      ".local/share/direnv/allow"
    ];
  };
}
