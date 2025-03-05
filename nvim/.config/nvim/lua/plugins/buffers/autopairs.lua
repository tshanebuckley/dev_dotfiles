return {
	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag")
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			-- configure autopairs
			require("nvim-autopairs").setup({
				disable_filetypes = { "TelescopePrompt", "spectre_panel" },
				-- integrate treesitter
				check_ts = true,
				ts_config = {
					lua = { "string" },
					javascript = { "template_string" },
					java = false,
				},
			})

			-- hook autopairs into cmp
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			local handlers = require("nvim-autopairs.completion.handlers")
			cmp.event:on(
				"confirm_done",
				cmp_autopairs.on_confirm_done({
					filetypes = {
						["*"] = {
							["("] = {
								kind = {
									cmp.lsp.CompletionItemKind.Function,
									cmp.lsp.CompletionItemKind.Method,
								},
								handler = handlers["*"],
							},
						},
					},
					tex = false,
				})
			)
		end,
	},
}
