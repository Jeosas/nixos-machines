{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      # Apps
      alpha-nvim
      nvim-tree-lua
      nvim-web-devicons
      toggleterm-nvim
      which-key-nvim

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

      # Treesitter
      nvim-treesitter.withAllGrammars
      playground

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
      nodePackages.vscode-langservers-extracted
      nodePackages.yaml-language-server
      nodePackages.bash-language-server
      (python3.withPackages (ps: with ps; [
        ipython
        mypy
        pylsp-mypy
        ruff
        python-lsp-ruff
        python-lsp-server
      ]))
      rust-analyzer
      marksman
      nodePackages.svelte-language-server
      nodePackages.typescript
      nodePackages.typescript-language-server
      rnix-lsp

      # Telescope dependencies
      ripgrep
      fd

      # Neede form grammar compilation
      tree-sitter
    ];
  };

  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };

  programs.zsh.shellAliases.nv = "nvim";
}
