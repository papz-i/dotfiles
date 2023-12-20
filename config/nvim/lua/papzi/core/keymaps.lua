-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>")

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>")

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- window management
keymap.set("n", "<leader>wv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>wh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>we", "<C-w>=") -- make split windows equal width & height
keymap.set("n", "<leader>wx", ":close<CR>") -- close current split window

keymap.set("n", "<leader>to", ":tabnew<CR>") -- open new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>") --  go to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") --  go to previous tab

-- Plugins

-- nvim-tree
keymap.set("n", "<leader>f", ":NvimTreeToggle<CR>") -- toggle file explorer

-- telescope
keymap.set("n", "<leader>sf", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>ss", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
keymap.set("n", "<leader>sc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
keymap.set("n", "<leader>sb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>sh", "<cmd>Telescope help_tags<cr>") -- list available help tags
