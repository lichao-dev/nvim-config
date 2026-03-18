-- config/keymaps.lua

local map = vim.keymap.set
local opt = { noremap = true, silent = true }

-- 快速保存 / 退出
map("n", "<leader>w", ":w<CR>", opt)
map("n", "<leader>q", ":q<CR>", opt)
map("n", "<leader>Q", ":qa!<CR>", opt)

-- 分屏移动：Ctrl + h/j/k/l
map("n", "<C-h>", "<C-w>h", opt)
map("n", "<C-j>", "<C-w>j", opt)
map("n", "<C-k>", "<C-w>k", opt)
map("n", "<C-l>", "<C-w>l", opt)

-- 分屏大小调整
map("n", "<A-Left>", ":vertical resize -5<CR>", opt)
map("n", "<A-Right>", ":vertical resize +5<CR>", opt)
map("n", "<A-Up>", ":resize +2<CR>", opt)
map("n", "<A-Down>", ":resize -2<CR>", opt)

-- Buffer 切换
map("n", "<S-l>", ":bnext<CR>", opt)
map("n", "<S-h>", ":bprevious<CR>", opt)

-- 自动换行（软换行）：类似 VS Code 的 Alt + Z
-- wrap：只影响显示，不会改文件内容
-- Alt + Z：切换软换行
map("n", "<M-z>", function()
	vim.wo.wrap = not vim.wo.wrap
end, opt)
