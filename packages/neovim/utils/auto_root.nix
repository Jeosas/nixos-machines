{
  extraConfigLuaPost =
    # lua
    ''
      local AutoRootCache = {}

      local find_root = function(buf_id)
        local names = {
          ".git",
          ".jj",
          "justfile",
          "Makefile",
          "=~",
        }

        buf_id = buf_id or 0
        if not type(buf_id) == 'number' or not vim.api.nvim_buf_is_valid(buf_id) then error('Argument `buf_id` of `find_root()` should be valid buffer id.') end

        -- Compute directory to start search from. NOTEs on why not using file path:
        -- - This has better performance because `vim.fs.find()` is called less.
        -- - *Needs* to be a directory for callable `names` to work.
        -- - Later search is done including initial `path` if directory, so this
        --   should work for detecting buffer directory as root.
        local path = vim.api.nvim_buf_get_name(buf_id)
        if path == "" then return end
        local dir_path = vim.fs.dirname(path)

        -- Try using cache
        local res = AutoRootCache[dir_path]
        if res ~= nil then return res end

        -- Find root
        local root_file = vim.fs.find(names, { path = dir_path, upward = true })[1]
        if root_file ~= nil then
          res = vim.fs.dirname(root_file)
        else
          res = dir_path
        end

        -- Use absolute path to an existing directory
        if type(res) ~= 'string' then return end
        res = vim.fs.normalize(vim.fn.fnamemodify(res, ':p'))
        if vim.fn.isdirectory(res) == 0 then return end

        -- Cache result per directory path
        AutoRootCache[dir_path] = res

        return res
      end

      -- Setup auto root
      vim.o.autochdir = false
      vim.api.nvim_create_autocmd(
        'BufEnter', 
        {
          group = vim.api.nvim_create_augroup('AutoRoot', {}),
          nested = true,
          callback = vim.schedule_wrap(
            function(data)
              if data.buf ~= vim.api.nvim_get_current_buf() then return end
              local root = find_root(data.buf)
              if root == nil then return end
              vim.fn.chdir(root)
            end
          ),
          desc = 'Find root and change current directory'
        }
      )
       
    '';
}
