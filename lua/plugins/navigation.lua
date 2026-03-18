return {

	-- 函数 / 类大纲（侧边栏）
	{
		"simrat39/symbols-outline.nvim",
		cmd = "SymbolsOutline",
		keys = {
			{ "<F8>", "<cmd>SymbolsOutline<CR>", desc = "Symbols Outline" },
		},
		config = function()
			require("symbols-outline").setup({
				auto_close = false,
				highlight_hovered_item = true,
			})
		end,
	},
}
