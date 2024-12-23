{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    (python3.withPackages (
      ps: with ps; [
        python-lsp-server
        python-lsp-ruff
        ruff
        mypy
      ]
    ))
  ];

  plugins = {
    lsp.servers.pylsp = {
      enable = true;
    };
    conform-nvim.settings.formatters_by_ft = {
      python = [
        "ruff_fix"
        "ruff_format"
        "ruff_organize_imports"
      ];
    };
    lint.lintersByFt = {
      python = [
        "ruff"
        "mypy"
      ];
    };
  };
}
