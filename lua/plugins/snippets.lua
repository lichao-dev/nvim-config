-- lua/plugins/snippets.lua
return {
	{
		"rafamadriz/friendly-snippets",
		enabled = true,
		event = "InsertEnter", -- 只在插入模式首次进入时加载，可加快启动速度
		config = function()
			-- 调用 VS Code 格式的加载器，自动加载 friendly‑snippets 中的所有片段
			require("luasnip.loaders.from_vscode").lazy_load()
			-- 加载自定义片段（优先级更高，会覆盖同名片段）
			require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
		end,
	},
}
