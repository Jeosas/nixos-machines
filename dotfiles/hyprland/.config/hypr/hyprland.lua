require("modules.critical")

require("modules.keybinds")
require("modules.style")
require("modules.misc")

local ok, _ = pcall(__require, "input")
if not ok then
	hl.config({
		input = {
			follow_mouse = 2,
			kb_layout = "us",
			kb_variant = "altgr-intl",
		},
	})
end

local ok, _ = pcall(__require, "monitors")
if not ok then
	hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
end

hl.on("hyprland.start", function()
	hl.exec_cmd("/nix/store/qj7950jbdqhg3w1kmifd3wbghli5x9gm-noctalia-shell-4.7.6/bin/noctalia-shell")
end)
