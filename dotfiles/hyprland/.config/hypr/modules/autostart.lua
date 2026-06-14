hl.on("hyprland.start", function()
	hl.exec_cmd("noctalia-shell")
end)

hl.on("config.reloaded", function()
	hl.exec_cmd("noctalia-shell")
end)
