return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"antosha417/nvim-lsp-file-operations",
		},
		opts = {
			diagnostics = {
				underline = true,
				update_in_insert = true,
			},
		},
		config = function()
			-- include this in all lsp setup methods
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")
			-- base lsp setup
			lspconfig.lua_ls.setup({
				settings = {
					capabilities = capabilities,
					-- we want to ignore the global 'vim' variable for neovim
					Lua = {
						diagnostics = {
							globals = {
								"vim",
							},
						},
					},
				},
			})
			-- have our diagnostics remain visible while editing
			vim.lsp.handlers["textDocument/publishDiagnostics"] =
				vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
					-- delay update diagnostics
					update_in_insert = true,
				})
			-- ensure that lsp import renaming is to include file operations
			-- lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
			-- 	capabilities = vim.tbl_deep_extend(
			-- 		"force",
			-- 		vim.lsp.protocol.make_client_capabilities(),
			-- 		require("lsp-file-operations").default_capabilities()
			-- 	),
			-- })
			-- add our key bindings
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "<leader>rn", function()
				return ":IncRename " .. vim.fn.expand("<cword>")
			end, { expr = true })
		end,
	},
}
