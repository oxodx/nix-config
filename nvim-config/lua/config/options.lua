vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true

opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.confirm = true

opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"
opt.hlsearch = true

opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.smartindent = true
opt.breakindent = true

opt.splitbelow = true
opt.splitright = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false

opt.completeopt = { "menuone", "noselect" }
opt.updatetime = 250
opt.timeoutlen = 1000
opt.winborder = "rounded" -- needs Neovim 0.11+

opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.diagnostic.config({
  severity_sort = true,
  update_in_insert = false,
  virtual_text = { spacing = 2, source = "if_many" },
  float = { border = "rounded", source = true },
})
