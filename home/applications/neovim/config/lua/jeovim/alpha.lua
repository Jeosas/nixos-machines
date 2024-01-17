local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	return
end

local dashboard = require("alpha.themes.dashboard")

local buttonhl = function(shortcut, text, command)
	local button = dashboard.button(shortcut, text, command)
	button.opts.hl_shortcut = "Label"
	return button
end

splash = {
	jeovim = {
		art = {
			[[     @@@  @@@@@@@@   @@@@@@   @@@  @@@  @@@  @@@@@@@@@@ ]],
			[[     @@@  @@@@@@@@  @@@@@@@@  @@@  @@@  @@@  @@@@@@@@@@@]],
			[[     @@!  @@!       @@!  @@@  @@!  @@@  @@!  @@! @@! @@!]],
			[[     !@!  !@!       !@!  @!@  !@!  @!@  !@!  !@! !@! !@!]],
			[[     !!@  @!!!:!    @!@  !@!  @!@  !@!  !!@  @!! !!@ @!@]],
			[[     !!!  !!!!!:    !@!  !!!  !@!  !!!  !!!  !@!   ! !@!]],
			[[     !!:  !!:       !!:  !!!  :!:  !!:  !!:  !!:     !!:]],
			[[!!:  :!:  :!:       :!:  !:!   ::!!:!   :!:  :!:     :!:]],
			[[::: : ::   :: ::::  ::::: ::    ::::     ::  :::     :: ]],
			[[ : :::    : :: ::    : :  :      :      :     :      :  ]],
		},
	},
	mountains = {
		art = {
			[[    .                  .-.    .  _   *     _   .                  ]],
			[[           *          /   \     ((       _/ \       *    .        ]],
			[[         _    .   .--'\/\_ \     `      /    \  *   ___           ]],
			[[     *  / \_    _/ ^      \/\'__       /\/\  /\  __/   \ *        ]],
			[[       /    \  /    .'   _/  /  \  *' /    \/  \/ .`'\_/\   .     ]],
			[[  .   /\/\  /\/ :' __  ^/  ^/    `--./.'  ^  `-.\ _    _:\ _      ]],
			[[     /    \/  \  _/  \-' __/.' ^ _   \_   .'\   _/ \ .  __/ \     ]],
			[[   /\  .-   `. \/     \ / -.   _/ \ -. `_/   \ /    `._/  ^  \    ]],
			[[  /  `-.__ ^   / .-'.--'    . /    `--./ .-'  `-.  `-. `.  -  `.  ]],
			[[@/        `.  / /      `-.   /  .-'   / .   .'   \    \  \  .-  \%]],
			[[@&8jgs@@%% @)&@&(88&@.-_=_-=_-=_-=_-=_.8@% &@&&8(8%@%8)(8@%8 8%@)%]],
			[[@88:::&(&8&&8:::::%&`.~-_~~-~~_~-~_~-~~=.'@(&%::::%@8&8)::&#@8::::]],
			[[`::::::8%@@%:::::@%&8:`.=~~-.~~-.~~=..~'8::::::::&@8:::::&8:::::' ]],
			[[ `::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.'  ]],
			[[]],
			[[                      Already feels like home...                  ]],
		},
	},
}

local active_splash = "mountains"

dashboard.section.header.val = splash[active_splash].art
dashboard.section.buttons.val = {
	buttonhl("e", "  New file", ":ene <BAR> startinsert <CR>"),
	buttonhl("SPC f f", "󰍉  Find file", ":Telescope find_files <CR>"),
	buttonhl("SPC p p", "  Find project", ":Telescope projects <CR>"),
	buttonhl("SPC f r", "  Recently used files", ":Telescope oldfiles <CR>"),
}

-- local function footer()
--	 return ""
-- end

-- dashboard.section.footer.val = footer()

dashboard.section.header.opts.hl = "String"
-- dashboard.section.footer.opts.hl = "Type"

dashboard.opts.opts.noautocmd = true
alpha.setup(dashboard.opts)
