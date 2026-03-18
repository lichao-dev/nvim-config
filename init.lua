-- init.lua：入口，只负责加载配置
require("config.options")   -- 基础选项
require("config.keymaps")   -- 基础按键
require("config.lazy")      -- 插件 & LSP 等

