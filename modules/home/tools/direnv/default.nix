{
  lib,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.tools.direnv;
in
  with lib;
  with lib.${namespace}; {
    options.${namespace}.tools.direnv = {enable = mkEnableOption "direnv";};

    config = mkIf cfg.enable {
      programs.direnv = {
        enable = true;
        enableZshIntegration = config.${namespace}.tools.zsh.enable;

        nix-direnv.enable = true;
      };

      xdg.configFile."direnv/direnvrc" = {
        text =
          /*
          bash
          */
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

      ${namespace}.impermanence.directories = [".local/share/direnv/allow"];
    };
  }
