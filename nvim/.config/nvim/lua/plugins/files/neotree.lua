return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim",
		},
		config = function()
			require("neo-tree").setup({
				event_handlers = {
					{
						event = "file_renamed",
						handler = function(args)
							-- args.source will be the old file path
							-- args.destination will be the new file path
							require("lsp-file-operations").move(args.source, args.destination)
						end,
					},
					{
						event = "file_moved",
						handler = function(args)
							require("lsp-file-operations").move(args.source, args.destination)
						end,
					},
					{
						event = "file_removed",
						handler = function(args)
							require("lsp-file-operations").delete(args.path)
						end,
					},
				},
			})
			vim.keymap.set("n", "<leader>n", ":Neotree filesystem reveal left<CR>")
		end,
	},
	{
		"antosha417/nvim-lsp-file-operations",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-neo-tree/neo-tree.nvim",
		},
		config = function()
			require("lsp-file-operations").setup()
		end,
	},
}
