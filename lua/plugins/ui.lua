-- plugins/ui.lua

return {

	-- 主题：One Dark Pro
	{
		"olimorris/onedarkpro.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("onedarkpro").setup({})
			require("onedarkpro").load()
		end,
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"c",
					"cpp",
					"python",
					"bash",
					"cmake",
					"make",
					"lua",
					"ini",
					"json",
					"markdown",
					"markdown_inline",
				},
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},

	-- 顶部栏
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({
				options = {
					diagnostics = "nvim_lsp",
					separator_style = "slant", -- 让顶部更漂亮
				},
			})
		end,
	},

	-- 状态栏：lualine（漂亮版）
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- 需要 Nerd Font 才能显示好看图标
		config = function()
			-- 获取当前附着的 LSP 名称（例如 pyright / clangd）
			local function lsp_name()
				local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
				local clients = vim.lsp.get_clients()
				if next(clients) == nil then
					return "No LSP"
				end
				for _, client in ipairs(clients) do
					local filetypes = client.config.filetypes
					if filetypes and vim.tbl_contains(filetypes, buf_ft) then
						return client.name
					end
				end
				return "No LSP"
			end

			require("lualine").setup({
				options = {
					theme = "onedark", -- 和 onedarkpro 颜色相近
					globalstatus = true, -- 一条全局状态栏
					-- Powerline 风格分隔符
					section_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },
					disabled_filetypes = { "lazy", "mason" },
				},
				sections = {
					-- 左侧：模式
					lualine_a = {
						{ "mode", icon = "" },
					},
					-- 左中：Git + 诊断
					lualine_b = {
						{ "branch", icon = "" },
						{ "diff" },
						{
							"diagnostics",
							sources = { "nvim_diagnostic" },
							sections = { "error", "warn", "info", "hint" },
							symbols = { error = " ", warn = " ", info = " ", hint = " " },
						},
					},
					-- 中间：文件名（带相对路径）
					lualine_c = {
						{
							"filename",
							path = 1, -- 0: 文件名  1: 相对路径  2: 绝对路径
							symbols = {
								modified = " ●", -- 未保存
								readonly = " ",
								unnamed = "[No Name]",
							},
						},
					},
					-- 右中：LSP 名称 + 文件编码/格式/类型
					lualine_x = {
						{ lsp_name, icon = "" },
						"encoding",
						"fileformat",
						"filetype",
					},
					-- 右侧：进度百分比
					lualine_y = {
						{ "progress" },
					},
					-- 最右：行列号
					lualine_z = {
						{ "location" },
					},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
			})
		end,
	},

	-- 文件模糊搜索：telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local telescope = require("telescope")
			telescope.setup({})
			local builtin = require("telescope.builtin")

			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help" })

			vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "File symbols (LSP)" })
			vim.keymap.set("n", "<leader>fw", builtin.lsp_workspace_symbols, { desc = "Workspace symbols (LSP)" })
		end,
	},

	-- Git 标记：gitsigns
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},

	-- 注释：gcc / gc
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},

	-- 自动补全括号
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},

	-- 文件树（像 VSCode 那样）
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({
				view = {
					width = 32,
					side = "left",
				},
				renderer = {
					highlight_git = true,
					icons = {
						glyphs = {
							default = "",
							symlink = "",
							folder = {
								default = "",
								open = "",
								empty = "",
								empty_open = "",
							},
						},
					},
				},
				update_focused_file = {
					enable = true,
					update_cwd = true,
				},
			})

			-- <leader>e 打开/关闭文件树（和 VSCode 类似）
			vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle File Tree" })
		end,
	},
}
