return {
	"rebelot/kanagawa.nvim",
	config = function()
		require("kanagawa").setup({
			theme = "wave",
			background = {
				dark = "dragon",
				light = "wave",
			},
		})
	end,
}
