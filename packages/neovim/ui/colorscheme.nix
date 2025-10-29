{ lib, config, ... }:
{
  colorschemes.nord = {
    enable = true;
    settings = {
      enable_sidebar_background = false;
      borders = true;
      contrast = true;
      cursorline_transparent = false;
      disable_background = true;
      italic = true;
      bold = true;
      uniform_diff_background = false;
    };
  };

  extraConfigLuaPost =
    lib.mkIf config.colorschemes.nord.enable # lua
      ''
        local colors = require('nord.colors')
        require('nord.util').highlight('LspInlayHint',
          { fg = colors.nord3_gui_bright, style = 'italic' }
        )
      '';
}
