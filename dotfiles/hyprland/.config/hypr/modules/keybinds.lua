--
-- Apps
--

hl.bind("SUPER + SHIFT + Return", hl.dsp.exec_cmd("mullvad-browser"))
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m region"))

--
-- Shell
--

hl.bind("SUPER + d", hl.dsp.exec_cmd("wofi --show drun"))
hl.bind("SUPER + v", hl.dsp.exec_cmd("ghostty -e wiremix"))
hl.bind("SUPER + b", hl.dsp.exec_cmd("ghostty -e bluetuith"))
hl.bind("SUPER + n", hl.dsp.exec_cmd("ghostty -e nmtui"))
hl.bind("SUPER + SHIFT + d", hl.dsp.exec_cmd("hyprlock"))

--
-- Move
--

hl.bind("SUPER + mouse:272", hl.dsp.window.drag())

hl.bind("SUPER + h", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + l", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + k", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + j", hl.dsp.focus({ direction = "down" }))

hl.bind("SUPER + q", hl.dsp.focus({ workspace = 1 }))
hl.bind("SUPER + w", hl.dsp.focus({ workspace = 2 }))
hl.bind("SUPER + e", hl.dsp.focus({ workspace = 3 }))
hl.bind("SUPER + r", hl.dsp.focus({ workspace = 4 }))
hl.bind("SUPER + t", hl.dsp.focus({ workspace = 5 }))
hl.bind("SUPER + y", hl.dsp.focus({ workspace = 6 }))
hl.bind("SUPER + u", hl.dsp.focus({ workspace = 7 }))
hl.bind("SUPER + i", hl.dsp.focus({ workspace = 8 }))
hl.bind("SUPER + o", hl.dsp.focus({ workspace = 9 }))
hl.bind("SUPER + p", hl.dsp.focus({ workspace = 10 }))

--
-- Window
--

hl.bind("SUPER + SHIFT + a", hl.dsp.window.close())
hl.bind("SUPER + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + f", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))

hl.bind("SUPER + SHIFT + semicolon", hl.dsp.window.pin())
hl.bind("SUPER + SHIFT + h", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + l", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + SHIFT + k", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + j", hl.dsp.window.move({ direction = "d" }))

hl.bind("SUPER + SHIFT + q", hl.dsp.window.move({ workspace = 1, follow = false }))
hl.bind("SUPER + SHIFT + w", hl.dsp.window.move({ workspace = 2, follow = false }))
hl.bind("SUPER + SHIFT + e", hl.dsp.window.move({ workspace = 3, follow = false }))
hl.bind("SUPER + SHIFT + r", hl.dsp.window.move({ workspace = 4, follow = false }))
hl.bind("SUPER + SHIFT + t", hl.dsp.window.move({ workspace = 5, follow = false }))
hl.bind("SUPER + SHIFT + y", hl.dsp.window.move({ workspace = 6, follow = false }))
hl.bind("SUPER + SHIFT + u", hl.dsp.window.move({ workspace = 7, follow = false }))
hl.bind("SUPER + SHIFT + i", hl.dsp.window.move({ workspace = 8, follow = false }))
hl.bind("SUPER + SHIFT + o", hl.dsp.window.move({ workspace = 9, follow = false }))
hl.bind("SUPER + SHIFT + p", hl.dsp.window.move({ workspace = 10, follow = false }))

hl.bind("SUPER + CTRL + h", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + CTRL + l", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + CTRL + k", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind("SUPER + CTRL + j", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })

--
-- Workspace
--
hl.bind("SUPER + CTRL + SHIFT + h", function()
	local w = hl.get_active_workspace()
	if not w then
		return
	end
	hl.dispatch(hl.dsp.workspace.move({ workspace = w.id, monitor = "l" }))
end)
hl.bind("SUPER + CTRL + SHIFT + l", function()
	local w = hl.get_active_workspace()
	if not w then
		return
	end
	hl.dispatch(hl.dsp.workspace.move({ workspace = w.id, monitor = "r" }))
end)
hl.bind("SUPER + CTRL + SHIFT + k", function()
	local w = hl.get_active_workspace()
	if not w then
		return
	end
	hl.dispatch(hl.dsp.workspace.move({ workspace = w.id, monitor = "u" }))
end)
hl.bind("SUPER + CTRL + SHIFT + j", function()
	local w = hl.get_active_workspace()
	if not w then
		return
	end
	hl.dispatch(hl.dsp.workspace.move({ workspace = w.id, monitor = "d" }))
end)

--
-- Media
--

hl.bind("XF86AudioMute", hl.dsp.exec_cmd("volumectl"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl down"), { locked = true, repeating = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("volumectl up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("volumectl down"), { locked = true, repeating = true })
