local opts = { noremap = true, silent = true }
--
-- Set map leader
vim.g.mapleader = " "

-- File management keybind
vim.keymap.set({ "n", "v", "x" }, "<C-s>", ":silent write<CR>", opts)
vim.keymap.set("n", "<leader>sw", ":silent write<CR>", opts)

-- General keybind
vim.keymap.set("n", "<leader>nh", vim.cmd.nohlsearch, opts)
vim.keymap.set({ "n", "v", "x" }, "x", '"_x')

-- Window management keybind
vim.keymap.set("n", "<leader>sr", "<C-w>v", opts)
vim.keymap.set("n", "<leader>st", "<C-w>s", opts)
vim.keymap.set("n", "<leader>se", "<C-w>=", opts)
vim.keymap.set("n", "<leader>sx", ":close<CR>", opts)
vim.keymap.set("n", "<leader>sh", "<C-w>h<CR>", opts)
vim.keymap.set("n", "<leader>sl", "<C-w>l<CR>", opts)
vim.keymap.set("n", "<leader>sj", "<C-w>j<CR>", opts)
vim.keymap.set("n", "<leader>sk", "<C-w>k<CR>", opts)

-- Resize with arrows when using multiple windows
vim.keymap.set("n", "<C-Up>", ":resize -2<CR>", { silent = true, remap = true })
vim.keymap.set("n", "<c-down>", ":resize +2<cr>", { silent = true, remap = true })
vim.keymap.set("n", "<c-right>", ":vertical resize -2<cr>", { silent = true, remap = true })
vim.keymap.set("n", "<c-left>", ":vertical resize +2<cr>", { silent = true, remap = true })

--- Keymap Stolen from https://github.com/ThePrimeagen/
-- Move highlighted
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true, remap = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true, remap = true })

vim.keymap.set("n", "J", "mzJ`z", opts)
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)

-- Greatest remap ever
vim.keymap.set("v", "p", '"_dP', opts)

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], opts)
vim.keymap.set("n", "<leader>Y", [["+Y]], opts)
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], opts)

vim.keymap.set("n", "Q", "<nop>", opts)

vim.keymap.set("n", "<leader>S", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
