-- config/options.lua

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

-- 编码设置
-- encoding：Neovim 内部使用 UTF-8 处理文本
-- fileencodings：打开文件时按顺序尝试这些编码，避免中文文件乱码
opt.encoding = "utf-8"
opt.fileencodings = { "utf-8", "gbk", "gb18030" }

opt.mouse = "a"
-- 禁用右键点击的所有行为
vim.keymap.set({ "n", "v", "i", "c" }, "<RightMouse>", "<NOP>")

opt.termguicolors = true -- 真彩色
opt.number = true -- 行号
opt.relativenumber = true -- 相对行号
opt.cursorline = true -- 高亮当前行
opt.signcolumn = "yes" -- 永远显示 sign 列

--- 使用Tree_sitter 作为折叠引擎
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

--- 启动时不要全部折叠
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

opt.splitright = true
opt.splitbelow = true

opt.scrolloff = 5
opt.wrap = false
opt.clipboard = "unnamedplus" -- 关联系统剪贴板

vim.opt.updatetime = 500

-- linebreak：尽量在单词/空格处换行（更好读）
-- breakindent：换行后的续行缩进对齐（更好看日志/JSON）
vim.opt.linebreak = true
vim.opt.breakindent = true

-- 文件被外部修改时自动刷新
opt.autoread = true
-- 所有事件都检查，因为日志文件通常只读
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
	pattern = { "*.log", "*access.log", "*error.log" }, -- 限定文件类型
	command = "checktime",
})

-- options.lua 里最后加上
vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

-- CursorHold 时自动弹出 Lspsaga 的诊断浮窗
-- vim.api.nvim_create_autocmd("CursorHold", {
-- 	callback = function()
-- 		-- 如果 lspsaga 没加载成功，就用内置浮窗兜底（防止报错）
-- 		local ok = pcall(require, "lspsaga")
-- 		if ok then
-- 			vim.cmd("Lspsaga show_line_diagnostics")
-- 		else
-- 			vim.diagnostic.open_float(nil, {
-- 				focusable = false,
-- 				border = "rounded",
-- 				source = "always",
-- 				prefix = " ",
-- 				scope = "cursor",
-- 			})
-- 		end
-- 	end,
-- })
