--
-- Apps
--

hl.bind("SUPER + SHIFT + Return", hl.dsp.exec_cmd("mullvad-browser"))
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m region"))

--
-- Shell
--

hl.bind("SUPER + d", hl.dsp.exec_cmd("noctalia-shell ipc call launcher toggle"))
hl.bind("SUPER + c", hl.dsp.exec_cmd("noctalia-shell ipc call controlCenter toggle"))
hl.bind("SUPER + v", hl.dsp.exec_cmd("noctalia-shell ipc call volume togglePanel"))
hl.bind("SUPER + b", hl.dsp.exec_cmd("noctalia-shell ipc call bluetooth togglePanel"))
hl.bind("SUPER + n", hl.dsp.exec_cmd("noctalia-shell ipc call network togglePanel"))
hl.bind("SUPER + SHIFT + d", hl.dsp.exec_cmd("noctalia-shell ipc call lockScreen lock"))
hl.bind("SUPER + SHIFT + q", hl.dsp.exec_cmd("noctalia-shell ipc call sessionMenu toggle"))

--
-- Move
--

hl.bind("SUPER + mouse:272", hl.dsp.window.drag())

hl.bind("SUPER + h", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + l", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + k", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + j", hl.dsp.focus({ direction = "down" }))

hl.bind("SUPER + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind("SUPER + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind("SUPER + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind("SUPER + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind("SUPER + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind("SUPER + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind("SUPER + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind("SUPER + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind("SUPER + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind("SUPER + 0", hl.dsp.focus({ workspace = 10 }))

--
-- Window
--

hl.bind("SUPER + SHIFT + a", hl.dsp.window.close())
hl.bind("SUPER + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + f", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))

hl.bind("SUPER + SHIFT + p", hl.dsp.window.pin())
hl.bind("SUPER + SHIFT + h", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + l", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + SHIFT + k", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + j", hl.dsp.window.move({ direction = "d" }))

hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = 1, follow = false }))
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = 2, follow = false }))
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = 3, follow = false }))
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = 4, follow = false }))
hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = 5, follow = false }))
hl.bind("SUPER + SHIFT + 6", hl.dsp.window.move({ workspace = 6, follow = false }))
hl.bind("SUPER + SHIFT + 7", hl.dsp.window.move({ workspace = 7, follow = false }))
hl.bind("SUPER + SHIFT + 8", hl.dsp.window.move({ workspace = 8, follow = false }))
hl.bind("SUPER + SHIFT + 9", hl.dsp.window.move({ workspace = 9, follow = false }))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = 10, follow = false }))

hl.bind("SUPER + CTRL + h", hl.dsp.layout("colresize -conf"), { repeating = true })
hl.bind("SUPER + CTRL + l", hl.dsp.layout("colresize +conf"), { repeating = true })
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

hl.bind("XF86AudioMute", hl.dsp.exec_cmd("noctalia-shell ipc call volume muteOutput"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("noctalia-shell ipc call volume muteInput"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("noctalia-shell ipc call media playPause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("noctalia-shell ipc call media pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("noctalia-shell ipc call media next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("noctalia-shell ipc call media previous"), { locked = true })

hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd("noctalia-shell ipc call brightness increase"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd("noctalia-shell ipc call brightness decrease"),
	{ locked = true, repeating = true }
)

hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("noctalia-shell ipc call volume increase"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("noctalia-shell ipc call volume decrease"),
	{ locked = true, repeating = true }
)
