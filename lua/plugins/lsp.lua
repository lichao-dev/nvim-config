-- plugins/lsp.lua

return {

	-------------------------------------------------------------------
	-- Mason：安装 LSP / DAP / Formatter
	-------------------------------------------------------------------
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},

	-------------------------------------------------------------------
	-- schemastore：给 jsonls 提供丰富的 JSON Schema（可选但推荐）
	-------------------------------------------------------------------
	{
		"b0o/schemastore.nvim",
		lazy = true,
	},

	-------------------------------------------------------------------
	-- mason-lspconfig：桥接 Mason 和 nvim-lspconfig（新 API 模式）
	-------------------------------------------------------------------
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "pyright", "clangd", "lua_ls", "bashls", "jsonls", "marksman" },
			})
		end,
	},

	-------------------------------------------------------------------
	-- nvim-cmp + LuaSnip：补全框架
	-------------------------------------------------------------------
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}),
			})
		end,
	},

	-------------------------------------------------------------------
	-- LSP 主配置：使用新 API vim.lsp.config / vim.lsp.enable
	-------------------------------------------------------------------
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local ok_conform, conform = pcall(require, "conform")

			local on_attach = function(_, bufnr)
				local buf_map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
				end

				-- 使用 lspsaga 映射 LSP 功能
				buf_map("n", "gd", "<cmd>Lspsaga goto_definition<CR>", "Goto Definition (Lspsaga)")
				buf_map("n", "gD", "<cmd>Lspsaga goto_type_definition<CR>", "Goto Type Definition (Lspsaga)")
				buf_map("n", "gi", "<cmd>Lspsaga finder imp<CR>", "Goto Implementation (Lspsaga)")
				buf_map("n", "gr", "<cmd>Lspsaga finder def+ref<CR>", "Goto References (Lspsaga)")
				buf_map("n", "K", "<cmd>Lspsaga hover_doc<CR>", "Hover Doc (Lspsaga)")
				buf_map("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", "Rename (Lspsaga)")
				buf_map("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", "Code Action (Lspsaga)")
				buf_map("n", "<leader>cA", vim.lsp.buf.code_action, "Code Action (native)")
				buf_map("n", "gf", "<cmd>Lspsaga finder<CR>", "Finder (Lspsaga)")
				buf_map("n", "gl", "<cmd>Lspsaga show_line_diagnostics<CR>", "Line Diagnostics (Lspsaga)")

				-- 统一格式化：优先用 conform（比如 stylua），否则退回 LSP 自带 format
				buf_map("n", "<leader>f", function()
					if ok_conform then
						conform.format({
							lsp_fallback = true,
							async = true,
							bufnr = bufnr,
						})
					else
						vim.lsp.buf.format({ async = true })
					end
				end, "Format buffer")

				-- 诊断跳转仍使用内置
				buf_map("n", "[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
				buf_map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
			end

			-- 配置各语言服务器
			vim.lsp.config("pyright", {
				capabilities = capabilities,
				on_attach = on_attach,
			})

			vim.lsp.config("clangd", {
				capabilities = capabilities,
				on_attach = on_attach,
				cmd = {
					"clangd",
					"--header-insertion=never", -- 关闭自动插入 #include
				},
			})

			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							checkThirdParty = false,
						},
						format = {
							enable = false,
						},
					},
				},
			})

			vim.lsp.config("bashls", {
				capabilities = capabilities,
				on_attach = on_attach,
			})

			vim.lsp.config("jsonls", {
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})

			vim.lsp.config("marksman", {
				capabilities = capabilities,
				on_attach = on_attach,
			})
		end,
	},

	-------------------------------------------------------------------
	-- lspsaga.nvim：LSP UI 增强
	-------------------------------------------------------------------
	{
		"nvimdev/lspsaga.nvim",
		event = "LspAttach",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("lspsaga").setup({
				ui = {
					border = "rounded",
				},
				symbol_in_winbar = {
					enable = true,
				},
			})
		end,
	},

	-------------------------------------------------------------------
	-- lsp_signature.nvim：函数参数提示（类似 VSCode 参数信息）
	-------------------------------------------------------------------
	{
		"ray-x/lsp_signature.nvim",
		event = "LspAttach", -- 等 LSP 真正 attach 到 buffer 时再加载
		config = function()
			-- 详细参数说明：
			-- bind：是否把 signature 的函数绑定到当前 buffer
			-- floating_window：是否使用浮窗显示参数信息
			-- hint_enable：是否在行内（虚拟文本）显示提示，这里先关掉
			-- handler_opts.border：浮窗边框样式，和你 lspsaga 保持一致用 rounded
			-- toggle_key：手动开关提示的按键，这里用 <C-k>，你可以根据自己习惯改
			require("lsp_signature").setup({
				bind = true,
				floating_window = true, -- ✅ 像 VSCode 那样弹一个小窗
				floating_window_above_cur_line = true, -- 尽量显示在当前行上方
				hint_enable = false, -- 先关掉虚拟文本提示，干净一点
				hi_parameter = "LspSignatureActiveParameter", -- 高亮当前参数
				handler_opts = {
					border = "rounded",
				},
				toggle_key = "<C-k>", -- 手动开/关参数提示
			})
		end,
	},

	-------------------------------------------------------------------
	-- trouble.nvim：诊断列表插件
	-------------------------------------------------------------------
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = { use_diagnostic_signs = true },
		keys = {
			-- 当前文件诊断
			{
				"<leader>xx",
				function()
					require("trouble").toggle({ mode = "diagnostics", focus = true, filter = { buf = 0 } })
				end,
				desc = "Document Diagnostics (Trouble)",
			},

			-- 整个 workspace 诊断
			{
				"<leader>xX",
				function()
					require("trouble").toggle({ mode = "diagnostics", focus = true })
				end,
				desc = "Workspace Diagnostics (Trouble)",
			},
		},
	},
}
