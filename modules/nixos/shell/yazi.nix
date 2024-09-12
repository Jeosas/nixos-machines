{
  pkgs,
  config,
  ...
}: {
  home-manager.users.${config.jeomod.user} = {
    home.packages = with pkgs; [ueberzugpp];

    programs.yazi = {
      enable = true;
      enableZshIntegration = true;

      settings = {
        manager = {
          show_hidden = true;
          show_simlink = true;
          scrolloff = 6; # scroll offset
          sort_by = "alphabetical";
          sort_dir_first = true;
          line_mode = "mtime";
        };
      };
      keymap = {
        manager = {
          prepend_keymap = [
            {
              on = ["l"];
              run = "plugin --sync smart-enter";
              desc = "Enter the child directory, or open the file";
            }
          ];
        };
      };
    };
    xdg.configFile."yazi/init.lua" = {
      text =
        /*
        lua
        */
        ''
          -- Full rounded border
          function Manager:render(area)
            local chunks = self:layout(area)

          	local bar = function(c, x, y)
          		x, y = math.max(0, x), math.max(0, y)
          		return ui.Bar(ui.Rect { x = x, y = y, w = ya.clamp(0, area.w - x, 1), h = math.min(1, area.h) }, ui.Bar.TOP)
          			:symbol(c)
          	end

            return ya.flat {
          		ui.Border(area, ui.Border.ALL):type(ui.Border.ROUNDED),
          		ui.Bar(chunks[1], ui.Bar.RIGHT),
          		ui.Bar(chunks[3], ui.Bar.LEFT),
          		bar("┬", chunks[1].right - 1, chunks[1].y),
          		bar("┴", chunks[1].right - 1, chunks[1].bottom - 1),
          		bar("┬", chunks[2].right, chunks[2].y),
            	bar("┴", chunks[2].right, chunks[1].bottom - 1),
          		Parent:render(chunks[1]:padding(ui.Padding.xy(1))),
          		Current:render(chunks[2]:padding(ui.Padding.y(1))),
          		Preview:render(chunks[3]:padding(ui.Padding.xy(1))),
            }
          end
        '';
    };
    xdg.configFile."yazi/plugins/smart-enter.yazi/init.lua" = {
      text =
        /*
        lua
        */
        ''
          return {
            entry = function()
              local h = cx.active.current.hovered
              ya.manager_emit(h and h.cha.is_dir and "enter" or "open", { hovered = true })
            end,
          }
        '';
    };
  };
}
