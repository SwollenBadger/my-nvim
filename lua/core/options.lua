vim.opt.shell = "zsh"

-- Diagnostic
vim.fn.sign_define("DiagnosticSignError", {
	text = "",
	texthl = "DiagnosticSignError",
})
vim.fn.sign_define("DiagnosticSignWarn", {
	text = "󱧡",
	texthl = "DiagnosticSignWarn",
})
vim.fn.sign_define("DiagnosticSignInfo", {
	text = "󰌵",
	texthl = "DiagnosticSignInfo",
})
vim.fn.sign_define("DiagnosticSignHint", {
	text = "󰛨",
	texthl = "DiagnosticSignHint",
})

-- Number
vim.opt.number = true
vim.opt.relativenumber = true

-- tab & indentation
vim.opt.smarttab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- line wrapping
vim.opt.wrap = false
vim.opt.colorcolumn = "80"

-- search setting
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- cursor line
vim.opt.cursorline = true
vim.opt.guicursor = ""

-- backspace
vim.opt.backspace = "indent,eol,start"

-- clipboard
vim.opt.clipboard:append("unnamedplus")

-- split window
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Additional
vim.opt.iskeyword:append("-")
vim.opt.cmdheight = 1
vim.opt.mousemoveevent = true

-- Option stolen from https://github.com/ThePrimeagen/
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.filetype.add({
	pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})
