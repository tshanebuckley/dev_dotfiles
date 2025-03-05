return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-dap.nvim",
		},
		config = function()
      -- Load any extensions
      require("telescope").load_extension("dap")
      local telescope = require("telescope")
			local builtin = require("telescope.builtin")
      local dap = telescope.extensions.dap
      --set keymaps
			vim.keymap.set("n", "<leader>flf", builtin.find_files, {})
			vim.keymap.set("n", "<leader>fgf", builtin.live_grep, {})
      vim.keymap.set("n", "<leader>fb", dap.list_breakpoints, {})
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
	},
}
