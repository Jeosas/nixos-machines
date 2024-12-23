{pkgs, ...}: {
  extraPackages = with pkgs; [stylua lua];

  plugins = {
    lsp.servers.lua_ls = {
      enable = true;

      settings = {
        Lua = {
          version = {version = "max";};
          diagnostics = {
            globals = ["vim"];
          };
          workspace = {
            library.__raw =
              # lua
              ''
                {
                  [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                  [vim.fn.stdpath("config") .. "/lua"] = true,
                }
              '';
          };
        };
      };
    };
    conform-nvim.settings.formatters_by_ft = {
      lua = ["stylua"];
      luau = ["stylua"];
    };
    lint.lintersByFt = {
      lua = ["luac"];
      luau = ["luac"];
    };
  };
}
