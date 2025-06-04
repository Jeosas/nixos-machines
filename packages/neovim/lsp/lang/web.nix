{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    djlint
    prettierd
    eslint_d
  ];

  plugins = {
    lsp.servers = {
      html.enable = true;
      emmet_language_server.enable = true;
      htmx.enable = true;
      ts_ls.enable = true;
      svelte.enable = true;
      tailwindcss.enable = true;
      cssls.enable = true;
    };

    conform-nvim.settings = {
      formatters = {
        djlint = {
          prepend_args = [
            "--indent"
            "2"
            "--max-line-length"
            "100"
          ];
        };
      };

      formatters_by_ft = {
        html = [ "djlint" ];
        htmldjango = [ "djlint" ];

        javascript = [ "prettierd" ];
        typescript = [ "prettierd" ];
        javascriptreact = [ "prettierd" ];
        typescriptreact = [ "prettierd" ];

        svelte = [ "prettierd" ];

        css = [ "prettierd" ];
        scss = [ "prettierd" ];
      };
    };

    lint.lintersByFt = {
      html = [ "djlint" ];
      htmldjango = [ "djlint" ];

      javascript = [ "eslint_d" ];
      typescript = [ "eslint_d" ];
      javascriptreact = [ "eslint_d" ];
      typescriptreact = [ "eslint_d" ];
    };
  };
}
