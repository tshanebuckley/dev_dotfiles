vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set inccommand=split")
vim.cmd("set cmdwinheight=20")
vim.opt.signcolumn = "auto:5"
vim.o.showtabline = 2
vim.opt.sessionoptions = "curdir,folds,globals,help,tabpages,terminal,winsize"
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
-- set our diagnostics icons
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
  },
})
-- apply undercurl for diagnostics
vim.cmd([[let &t_Cs = "\e[4:3m""]])
vim.cmd([[let &t_Ce = "\e[4:0m""]])
-- enable spell check
vim.opt.spell = true
vim.opt.spelllang = { "en_us" }
-- if we are in a wsl instance
if vim.env.WSL == "true" then
  -- fix for the clipboard
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["-"] = "clip.exe",
    },
    paste = {
      ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cahce_enabled = 0,
  }
  -- other fixes/changes as needed
end
vim.opt.number = true
vim.opt.relativenumber = true
-- we want to exit insert mode in terminal buffers with '<esc>'
vim.keymap.set("t", "<C-q>", [[<C-\><C-n>]])
-- add normal mode window navigations
vim.keymap.set("n", "<A-h>", [[<Cmd>wincmd h<CR>]])
vim.keymap.set("n", "<A-j>", [[<Cmd>wincmd j<CR>]])
vim.keymap.set("n", "<A-k>", [[<Cmd>wincmd k<CR>]])
vim.keymap.set("n", "<A-l>", [[<Cmd>wincmd l<CR>]])
-- add terminal mode window navigations
vim.keymap.set("t", "<A-h>", [[<Cmd>wincmd h<CR>]])
vim.keymap.set("t", "<A-j>", [[<Cmd>wincmd j<CR>]])
vim.keymap.set("t", "<A-k>", [[<Cmd>wincmd k<CR>]])
vim.keymap.set("t", "<A-l>", [[<Cmd>wincmd l<CR>]])
-- add insert mode cursor navigations
vim.keymap.set("i", "<A-h>", [[<Left>]])
vim.keymap.set("i", "<A-j>", [[<Down>]])
vim.keymap.set("i", "<A-k>", [[<Up>]])
vim.keymap.set("i", "<A-l>", [[<Right>]])
-- add command mode cursor navigations
vim.keymap.set("c", "<A-h>", [[<Left>]])
vim.keymap.set("c", "<A-j>", [[<Down>]])
vim.keymap.set("c", "<A-k>", [[<Up>]])
vim.keymap.set("c", "<A-l>", [[<Right>]])
-- add terminal mode cursor navigations
vim.keymap.set("t", "<A-h>", [[<Left>]])
vim.keymap.set("t", "<A-j>", [[<Down>]])
vim.keymap.set("t", "<A-k>", [[<Up>]])
vim.keymap.set("t", "<A-l>", [[<Right>]])
-- enable extmarks (helps virtual_lines below work properly)
vim.o.laststatus = 3
vim.o.cmdheight = 1
vim.o.showmode = false
vim.o.termguicolors = true
-- Disable default neovim text diagnostics in favor of lines
vim.diagnostic.config({ virtual_text = false })
vim.diagnostic.config({ virtual_lines = true })
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
-- only allow a single type of each diagnostic sign in the gutter
-- 1. Store original handlers
local orig_signs_handler = vim.diagnostic.handlers.signs
-- 2. Create custom signs handler to filter duplicates
vim.diagnostic.handlers.signs = {
  show = function(namespace, bufnr, diagnostics, opts)
    -- Create a map to track which lines already have a sign of each severity
    local used_lines = {}
    local filtered_diagnostics = {}

    for _, diagnostic in ipairs(diagnostics) do
      local severity = diagnostic.severity
      local line = diagnostic.lnum

      local key = string.format("%d", severity)
      used_lines[key] = used_lines[key] or {}

      -- Only add this diagnostic if we haven't seen this severity on this line
      if not used_lines[key][line] then
        used_lines[key][line] = true
        table.insert(filtered_diagnostics, diagnostic)
      end
    end
    -- Call original handler with filtered diagnostics
    orig_signs_handler.show(namespace, bufnr, filtered_diagnostics, opts)
  end,
  hide = function(namespace, bufnr)
    orig_signs_handler.hide(namespace, bufnr)
  end,
}
-- custom terminal opening function to open a terminal in insert mode
vim.api.nvim_create_user_command("StartTerm", function(opts)
  vim.cmd.terminal()
  vim.api.nvim_feedkeys("a", "t", false)
end, { nargs = 0 })
vim.api.nvim_create_user_command("WinTerm", function(opts)
  local newbuf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_open_win(newbuf, true, {
    split = "right",
    win = 0,
  })
  vim.cmd.terminal()
  vim.api.nvim_feedkeys("a", "t", false)
end, { nargs = 0 })
vim.keymap.set("n", "<leader>tt", ":WinTerm<CR>")
