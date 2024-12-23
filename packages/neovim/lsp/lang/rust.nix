{...}: {
  plugins = {
    lsp.servers.rust_analyzer = {
      enable = true;
      installRustc = true;
      installCargo = true;
      installRustfmt = true;
    };
    conform-nvim.settings.formatters_by_ft = {
      rust = ["rustfmt"];
    };
  };
}
