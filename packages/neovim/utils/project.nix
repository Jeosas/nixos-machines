{
  plugins.project-nvim = {
    enable = true;
    settings = {
      detection_methods = [
        "lsp"
        "pattern"
      ];
      ignore_lsp = [ "tsserve" ];
      patterns = [
        ".git"
        "_darcs"
        ".hg"
        ".bzr"
        ".svn"
        "Makefile"
        "package.json"
      ];
    };
  };
}
