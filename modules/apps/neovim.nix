{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.apps.neovim;
in
{
  options.${namespace}.apps.neovim = {
    enable = mkEnableOption "Neovim config";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.${namespace}.user.enableHomeManager;
        message = "Home-manager is not enabled.";
      }
    ];

    ${namespace} = {
      apps.stow.groups = [ "neovim" ];
    };

    environment.persistence.main = {
      users.${config.${namespace}.user.name}.directories = [
        ".local/share/nvim"
      ];
    };

    home-manager.users.${config.${namespace}.user.name} = {
      home = {
        packages = with pkgs; [
          neovim

          tree-sitter

          elmPackages.elm
          elmPackages.elm-format

          gopls
          go
          gotools
          golines
          gofumpt
          golangci-lint

          jq
          fixjson

          lua-language-server
          stylua
          lua

          prettierd

          nil
          nixfmt
          statix

          pkgs.${namespace}.maudfmt

          bash-language-server
          shfmt
          shellcheck

          sqruff

          terraform-ls
          trivy
          tflint
          tflint-plugins.tflint-ruleset-google

          texlab
          tex-fmt

          taplo

          tinymist
          typstyle
          websocat

          djlint
          prettierd
          eslint_d
          vscode-langservers-extracted
          typescript-language-server
          emmet-language-server
          svelte-language-server
          tailwindcss-language-server

          marksman

          yaml-language-server
          helm-ls
          yamlfmt
          yamllint
          actionlint
          shellcheck

          (python3.withPackages (
            ps: with ps; [
              python-lsp-server
              python-lsp-ruff
              ruff
              mypy
            ]
          ))
        ];
        sessionVariables = {
          EDITOR = "nvim";
        };
      };

      programs = {
        zsh.shellAliases.nv = "nvim";
        bash.shellAliases.nv = "nvim";
      };
    };
  };
}
