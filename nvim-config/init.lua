-- Entry point. Settings live in lua/config, plugins in lua/plugins.
-- The leader key has to be set before lazy.nvim loads any plugin.
require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")
