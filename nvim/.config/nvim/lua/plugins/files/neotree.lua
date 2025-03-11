return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim",
		},
		config = function()
			require("neo-tree").setup({
				vim.keymap.set("n", "<leader>n", ":Neotree filesystem reveal left<CR>")
			})
		end,
	},
}
