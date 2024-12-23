{
  plugins.project-nvim = {
    enable = true;
    settings = {
      detection_methods = [
        "lsp"
        "pattern"
      ];
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
