{
  plugins.project-nvim = {
    enable = true;
    settings = {
      detection_methods = [
        "pattern"
      ];
      ignore_lsp = [ "tsserve" ];
      patterns = [
        ".git"
        ".jj"
        "justfile"
        "Makefile"
        "=~"
      ];
    };
  };
}
