-- plugins/format.lua
-- 统一代码格式化（Lua 用 stylua，C/C++ 用 clang-format）

return {
  {
    "stevearc/conform.nvim",
    lazy = false,  -- 直接加载，方便在 LSP on_attach 里调用
    config = function()
      require("conform").setup({
        -- 格式化器按文件类型归类
        formatters_by_ft = {
          lua = { "stylua" },   -- Lua 用 stylua
          cpp = { "clang_format" }, -- C++ 用 clang-format
          c   = { "clang_format" }, -- C 用 clang-format
          python = { "black" }, -- Python 不使用外部格式器，走 LSP fallback
        },

        -- 可选：保存时自动格式化
        format_on_save = function(bufnr)
          local ft = vim.bo[bufnr].filetype
          if ft == "lua" then
            return { timeout_ms = 500, lsp_fallback = true }
          end
          return nil -- 其他文件不自动格式化
        end,
      })
    end,
  },
}

