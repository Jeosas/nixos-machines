return {
	system = {
		textlab = {
			build = {
				executable = "tectonic",
				args = { "-X", "compile", "%f", "--synctex", "--keep-logs", "--keep-intermediates" },
			},
		},
	},
}
