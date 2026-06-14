require("modules.critical")

require("modules.keybinds")
require("modules.style")
require("modules.misc")
require("modules.autostart")

-- Wait fix in 0.55.4
require("input")
-- local input_ok, err = pcall(require, "input")
-- if not input_ok then
-- 	hl.config({
-- 		input = {
-- 			follow_mouse = 2,
--
-- 			kb_layout = "us",
-- 			kb_variant = "altgr-intl",
--
-- 			touchpad = {
-- 				natural_scroll = false,
-- 			},
-- 		},
-- 	})
-- end

-- Wait fix in 0.55.4
require("monitors")
-- local monitor_ok, _ = pcall(require, "monitors")
-- if not monitor_ok then
-- 	hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
-- end
