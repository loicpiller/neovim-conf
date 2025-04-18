-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- For conciseness
local opts = { noremap = true, silent = true }

-- save file without auto-formatting
vim.keymap.set("n", "<C-s>", "<cmd>noautocmd w <CR>", opts)

-- quit file
vim.keymap.set("n", "<leader>q", "<cmd> q <CR>", opts)

-- quit NeoVim
vim.keymap.set("n", "<leader>Q", ":qa!<CR>", opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', opts)

-- Tabs
vim.keymap.set("n", "<leader>to", ":tabnew<CR>", opts) -- open new tab
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", opts) -- close current tab
vim.keymap.set("n", "<leader>tn", ":tabn<CR>", opts) --  go to next tab
vim.keymap.set("n", "<leader>tp", ":tabp<CR>", opts) --  go to previous tab

-- Toggle line wrapping
vim.keymap.set("n", "<leader>lw", "<cmd>set wrap!<CR>", opts)

-- Buffers
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", opts)
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", opts)
vim.keymap.set("n", "<leader>bd", ":bdelete!<CR>", opts) -- close buffer
vim.keymap.set("n", "<leader>bo", "<cmd> enew <CR>", opts) -- new buffer

-- Resize with arrows
vim.keymap.set("n", "<Up>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<Down>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<Left>", ":vertical resize +2<CR>", opts)
vim.keymap.set("n", "<Right>", ":vertical resize -2<CR>", opts)

-- Window management
vim.keymap.set("n", "<leader>v", "<C-w>v", opts) -- split window vertically
vim.keymap.set("n", "<leader>h", "<C-w>s", opts) -- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=", opts) -- make split windows equal width & height
vim.keymap.set("n", "<leader>sx", ":close<CR>", opts) -- close current split window

-- Navigate between splits
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", opts)
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", opts)
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", opts)
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", opts)

-- Tabs
vim.keymap.set("n", "<leader>to", ":tabnew<CR>", opts) -- open new tab
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", opts) -- close current tab
vim.keymap.set("n", "<leader>tn", ":tabn<CR>", opts) --  go to next tab
vim.keymap.set("n", "<leader>tp", ":tabp<CR>", opts) --  go to previous tab

-- Terminal
vim.keymap.set("n", "<leader>st", function()
	vim.cmd.vnew()
	vim.cmd.term()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 15)
end)
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)
