return {
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},
	{
		"echasnovski/mini.surround",
    event = "VeryLazy",
		config = function()
			require("mini.surround").setup({
				mappings = {
					find = "gs",
				},
			})
		end,
	},
}
