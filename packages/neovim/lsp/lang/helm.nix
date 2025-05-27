{ _, ... }:
{
  autoCmd = [
    {
      event = "FileType";
      pattern = "helm";
      command = "LspRestart";
    }
  ];

  plugins = {
    helm.enable = true;
    lsp.servers.helm_ls.enable = true;
  };
}
