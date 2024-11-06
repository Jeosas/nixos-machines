{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) readFile;
  inherit (lib.strings) concatStrings;

  fromGitHub = ref: repo:
    pkgs.vimUtils.buildVimPlugin {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = ref;
      src = builtins.fetchGit {
        url = "https://github.com/${repo}.git";
        ref = ref;
      };
    };

  cfg = config.jeomod.applications.neovim;
in
  with lib; {
    options.jeomod.applications.neovim = {
      enable = mkEnableOption "Neovim config";
    };

    config = mkIf cfg.enable {
      home-manager.users.${config.jeomod.user} = {
        programs.neovim = {
          enable = true;
          defaultEditor = true;

          extraLuaConfig = concatStrings [
            /*
            lua
            */
            ''
              require("jeovim.colorscheme")
              require("jeovim.cmp")
              require("jeovim.lsp")
              require("jeovim.telescope")
              require("jeovim.gitsigns")
              require("jeovim.treesitter")
              require("jeovim.autopairs")
              require("jeovim.comment")
              require("jeovim.nvim-tree")
              require("jeovim.lualine")
              require("jeovim.toggleterm")
              require("jeovim.project")
              require("jeovim.indentline")
              require("jeovim.tabby")
              require("jeovim.dressing")
              require("jeovim.ufo")
            ''
            (readFile ./autocommands.lua)
            (readFile ./options.lua)
            (readFile ./remap.lua)
          ];

          plugins = with pkgs.vimPlugins; [
            # Apps
            {
              plugin = alpha-nvim;
              type = "lua";
              config = readFile ./alpha.lua;
            }
            nvim-tree-lua
            nvim-web-devicons
            toggleterm-nvim
            nvim-ufo

            # Buffer / Tab line
            bufferline-nvim
            tabby-nvim

            # Status line
            lualine-nvim

            # UI
            dressing-nvim
            nord-nvim

            # Completion
            nvim-cmp
            cmp-buffer
            cmp-path
            cmp_luasnip
            cmp-nvim-lsp
            cmp-nvim-lua
            comment-nvim
            nvim-autopairs

            # Snippets
            luasnip
            friendly-snippets

            # LSP
            nvim-lspconfig
            {
              plugin = conform-nvim;
              type = "lua";
              config = readFile ./lsp/conform.lua;
            }
            {
              plugin = nvim-lint;
              type = "lua";
              config = readFile ./lsp/lint.lua;
            }

            # Telescope
            telescope-nvim
            project-nvim

            # Treesitter
            nvim-treesitter.withAllGrammars
            playground
            kmonad-vim

            # Git
            gitsigns-nvim
            plenary-nvim
            vim-bbye
            indent-blankline-nvim
          ];

          extraPackages = with pkgs; [
            # LSP
            ## misc
            sumneko-lua-language-server
            nodePackages.yaml-language-server
            nodePackages.bash-language-server
            marksman
            texlab
            ## python
            (python3.withPackages (ps:
              with ps; [
                python-lsp-server
                python-lsp-ruff
                ruff
                mypy
              ]))
            ## rust
            rust-analyzer
            ## web
            nodePackages.svelte-language-server
            nodePackages.typescript
            nodePackages.typescript-language-server
            vscode-langservers-extracted # html, json
            htmx-lsp
            ## nix
            nil

            # Format
            stylua
            alejandra
            nodePackages.prettier
            # --python ruff

            # Lint
            statix
            # --python mypy

            # Telescope dependencies
            ripgrep
            fd

            # Neede form grammar compilation
            tree-sitter

            # access clipboard on X11
            xclip
          ];
        };

        xdg.configFile.nvim = {
          source = ./config;
          recursive = true;
        };

        programs.zsh.shellAliases.nv = "nvim";
      };
    };
  }
