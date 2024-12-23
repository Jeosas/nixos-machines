{...}: {
  plugins.indent-blankline = {
    enable = true;
    settings = {
      exclude = {
        buftypes = [
          "terminal"
          "nofile"
        ];
        filetypes = [
          "help"
        ];
      };
    };
  };
}
