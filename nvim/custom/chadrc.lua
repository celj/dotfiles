local M = {}

local highlights = require("custom.highlights")

M.ui = {
  theme = "rosepine",
  theme_toggle = { "rosepine" },

  hl_override = highlights.override,
  hl_add = highlights.add,

  statusline = {
    theme = "minimal",
  },

  tabufline = {
    overriden_modules = function(modules)
      modules[4] = (function()
        return ""
      end)()
    end,
  },
}

M.plugins = "custom.plugins"

M.mappings = require("custom.mappings")

return M
