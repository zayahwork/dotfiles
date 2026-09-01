local map = vim.keymap.set

-- Esc saves. You press it anyway on the way back to normal mode.
map("i", "<Esc>", "<Esc><cmd>w<cr>", { desc = "Leave insert and save" })
map("n", "<Esc>", "<cmd>w<cr>", { desc = "Save" })

-- Select all, like everywhere else.
map("n", "<C-a>", "ggVG", { desc = "Select all" })

-- Paste over a selection without losing what you copied.
map("x", "p", [["_dP]], { desc = "Paste without clobbering the register" })

-- Delete to the void, keep the clipboard.
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

-- Move between splits.
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Keep the cursor centered when jumping.
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
