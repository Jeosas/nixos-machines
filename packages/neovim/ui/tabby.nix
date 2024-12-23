{pkgs, ...}: {
  opts.showtabline = 2; # always show tabline

  extraPlugins = with pkgs.vimPlugins; [tabby-nvim];
  extraConfigLua =
    # lua
    ''
      require("tabby").setup({
        line = function(line)
          return {
            {
              { "  " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. " ", hl = "TabLine" },
            },
            line.spacer(),
            line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
              return {
                line.sep(" ", "TabLine", "TabLine"),
                win.is_current() and " " or " ",
                win.buf_name(),
                line.sep(" ", "TabLine", "TabLine"),
                line.sep(" ", "TabLine", "TabLineFill"),
                hl = "TabLine",
              }
            end),
            {
              line.sep(" ", "TabLine", "TabLine"),
              { "  ", hl = "TabLine" },
            },
            hl = "TabLineFill",
          }
        end
      })
    '';
}
