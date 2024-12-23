{ ... }:
let
  options = {
    noremap = true;
    silent = true;
  };

  mkKeymap = mode: key: action: {
    inherit
      mode
      key
      action
      options
      ;
  };
in
{
  plugins.lsp = {
    enable = true;

    inlayHints = true;

    keymaps = {
      silent = true;
      diagnostic = {
        gl = "open_float";
      };
      lspBuf = {
        K = "hover";
        "<leader>la" = "code_action";
        "<leader>lf" = "format";
        "<leader>lr" = "rename";
      };
      extra = [
        (mkKeymap "n" "gd" "<cmd>Telescope lsp_definitions<cr>")
        (mkKeymap "n" "gD" "<cmd>Telescope lsp_references<cr>")
        (mkKeymap "n" "<leader>ld" "<cmd>Telescope lsp_diagnostics<cr>")
        (mkKeymap "n" "<leader>li" "<cmd>LspInfo<cr>")
        (mkKeymap "n" "<leader>ls" "<cmd>Telescope lsp_document_symbols<cr>")
        (mkKeymap "n" "<leader>lS" "<cmd>Telescope lsp_workspace_symbols<cr>")
      ];
    };

    postConfig =
      # lua
      ''
        local signs = {
        	{ name = "DiagnosticSignError", text = "" },
        	{ name = "DiagnosticSignWarn", text = "" },
        	{ name = "DiagnosticSignHint", text = "" },
        	{ name = "DiagnosticSignInfo", text = "" },
        }

        for _, sign in ipairs(signs) do
        	vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
        end

        vim.diagnostic.config({
        	virtual_text = true,
        	signs = {active = signs},
        	update_in_insert = true,
        	underline = true,
        	severity_sort = true,
        })
      '';
  };
}
