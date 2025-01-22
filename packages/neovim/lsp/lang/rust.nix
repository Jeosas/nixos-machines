{ ... }:
{
  plugins = {
    lsp.servers.rust_analyzer = {
      enable = true;

      # use devShell env
      installRustc = false;
      installCargo = false;
      installRustfmt = false;
    };
    conform-nvim.settings.formatters_by_ft = {
      rust = [ "rustfmt" ];
    };
  };
}
