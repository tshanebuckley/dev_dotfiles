return {
  {
    "folke/trouble.nvim",
    opts = {
      use_diagnostic_signs = true,
      action_keys = {
        close = { "q", "<esc>" },
        cancel = "<c-e>",
      },
    },
    cmd = "Trouble",
    keys = {
      {
        "<leader>dD",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Workspace Diagnostics",
      },
      {
        "<leader>dd",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Document Diagnostics",
      },
      {
        "<leader>dl",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Diagnostics Location List",
      },
    },
    config = function()
      require("trouble").setup()
    end,
  },
  {
    "maan2003/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
      -- turns on in-line diagnostics
      local function inline_diagnostics_on()
        vim.diagnostic.config({ virtual_lines = true })
      end
      -- turns off in-line diagnostics
      local function inline_diagnostics_off()
        vim.diagnostic.config({ virtual_lines = false })
      end
      -- turns on in-line diagnostics but only for the current line
      local function only_current_line()
        vim.diagnostic.config({ virtual_lines = { only_current_line = true } })
      end
      vim.keymap.set("", "<A-i>", inline_diagnostics_on, { desc = "Turn on in-line diagnostics" })
      vim.keymap.set("", "<A-o>", inline_diagnostics_off, { desc = "Turn off in-line diagnostics" })
      vim.keymap.set("", "<A-u>", only_current_line, { desc = "Turn on current-line diagnostics" })
    end,
  },
}
