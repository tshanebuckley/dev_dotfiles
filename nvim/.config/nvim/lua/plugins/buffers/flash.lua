return {
	"folke/flash.nvim",
	event = "VeryLazy",
	opts = {},
	keys = {
		{
			"<leader>jj",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = "Flash Jump",
		},
		{
			"<leader>jJ",
			mode = { "n", "x", "o" },
			function()
				require("flash").treesitter()
			end,
			desc = "Flash Treesitter Select",
		},
		{
			"<leader>jb",
			mode = { "n", "x", "o" },
			function()
				require("flash").treesitter({
					jump = {
						pos = { "end" },
					},
					highlight = { backdrop = true, matches = false },
				})
				local mode = vim.api.nvim_get_mode()["mode"]
				vim.api.nvim_feedkeys("%", mode, false)
			end,
			desc = "Flash Treesitter Jump Start",
		},
		{
			"<leader>je",
			mode = { "n", "x", "o" },
			function()
				require("flash").treesitter({
					jump = {
						pos = { "start" },
					},
					highlight = { backdrop = true, matches = false },
				})
			end,
			desc = "Flash Treesitter Jump End",
		},
		-- { "<leader>fs", mode = "o", function() require("flash").remote() end, desc = "Flash Treesitter Select" },
		-- { "<leader>fR", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
	},
}
