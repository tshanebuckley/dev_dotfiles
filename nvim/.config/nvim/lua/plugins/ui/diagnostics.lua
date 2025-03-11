return {
  {
    "folke/trouble.nvim",
    -- lazy = false,
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
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
    end
  },
}
