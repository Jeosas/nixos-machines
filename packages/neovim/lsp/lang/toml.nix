{...}: {
  plugins = {
    lsp.servers.taplo = {
      enable = true;
    };
    conform-nvim.settings.formatters_by_ft = {
      toml = ["taplo"];
    };
  };
}
