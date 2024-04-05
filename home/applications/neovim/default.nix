{ config, pkgs, lib, ... }:

let
  inherit (builtins) readFile;
  inherit (lib.strings) concatStrings;
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    extraLuaConfig = concatStrings [
      /* lua */
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
        require("jeovim.whichkey")
        require("jeovim.autocommands")
        require("jeovim.tabby")
        require("jeovim.dressing")
        require("jeovim.ufo")
      ''
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
      which-key-nvim
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
      none-ls-nvim

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
      # Lsp
      sumneko-lua-language-server
      stylua
      nodePackages.yaml-language-server
      nodePackages.bash-language-server
      (python3.withPackages (ps: with ps; [
        python-lsp-server
        python-lsp-ruff
        ruff
        mypy
      ]))
      rust-analyzer
      marksman
      nodePackages.svelte-language-server
      nodePackages.typescript
      nodePackages.typescript-language-server
      nil
      vscode-langservers-extracted # html, json
      htmx-lsp

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
}
