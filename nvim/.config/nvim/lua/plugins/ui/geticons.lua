return {
  "glepnir/nerdicons.nvim",
  opts = {
    down = "<c-j>",
    up = "<c-k>",
    register = '"',
  },
  cmd = "NerdIcons",
  conifg = function()
    require("nerdicons").setup()
  end,
}
