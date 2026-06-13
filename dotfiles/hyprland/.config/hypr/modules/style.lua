hl.curve("overshot", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({
	leaf = "border",
	enabled = true,
	speed = 2,
	bezier = "default",
})
hl.animation({
	leaf = "fade",
	enabled = true,
	speed = 3,
	bezier = "default",
})
hl.animation({
	leaf = "windows",
	enabled = true,
	speed = 3,
	bezier = "overshot",
	style = "popin 80%",
})
hl.animation({
	leaf = "workspaces",
	enabled = true,
	speed = 2,
	bezier = "default",
	style = "slide",
})

hl.workspace_rule({
	workspace = "1",
	default_name = "一",
})
hl.workspace_rule({
	workspace = "2",
	default_name = "二",
})
hl.workspace_rule({
	workspace = "3",
	default_name = "三",
})
hl.workspace_rule({
	workspace = "4",
	default_name = "四",
})
hl.workspace_rule({
	workspace = "5",
	default_name = "五",
})
hl.workspace_rule({
	workspace = "6",
	default_name = "六",
})
hl.workspace_rule({
	workspace = "7",
	default_name = "七",
})
hl.workspace_rule({
	workspace = "8",
	default_name = "八",
})
hl.workspace_rule({
	workspace = "9",
	default_name = "九",
})
hl.workspace_rule({
	workspace = "10",
	default_name = "十",
})

hl.config({
	animations = {
		enabled = true,
	},
	cursor = {
		enable_hyprcursor = true,
		inactive_timeout = 6,
		no_hardware_cursors = 0,
		use_cpu_buffer = 1,
		warp_on_change_workspace = 1,
	},
	decoration = {
		blur = {
			enabled = false,
		},
		rounding = 6,
	},
	general = {
		allow_tearing = false,
		border_size = 1,
		col = {
			active_border = { colors = { "rgba(a3be8cff)", "rgba(88c0d0ff)" }, angle = 45 },
			inactive_border = "rgba(2e3440cc)",
		},
		gaps_in = 4,
		gaps_out = 8,
		layout = "scrolling",
	},
	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
	},
})
